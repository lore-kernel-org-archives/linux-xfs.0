Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36970 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfBSXuC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Feb 2019 18:50:02 -0500
Subject: Re: [PATCH 1/3] xfs_io: don't pass negative len to
 copy_file_range_cmd
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
 <b48c8b5d-9ed3-c4b6-c7fc-2c13df211dd3@redhat.com>
 <20190219232415.GL32253@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <23623f74-0dc1-0ddc-989d-6eb4aabbee30@sandeen.net>
Date: Tue, 19 Feb 2019 17:50:01 -0600
MIME-Version: 1.0
In-Reply-To: <20190219232415.GL32253@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 2/19/19 5:24 PM, Darrick J. Wong wrote:
> On Tue, Feb 19, 2019 at 05:17:49PM -0600, Eric Sandeen wrote:
>> If copy_src_filesize returns an error (-1) we should return that
>> error, and not pass it to copy_file_range_cmd().
>>
>> Addresses-Coverity-ID: 1431684 ("Improper use of negative value")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
>> index 4e2969c..bc891c9 100644
>> --- a/io/copy_file_range.c
>> +++ b/io/copy_file_range.c
>> @@ -121,6 +121,10 @@ copy_range_f(int argc, char **argv)
>>  
>>  	if (src == 0 && dst == 0 && len == 0) {
>>  		len = copy_src_filesize(fd);
> 
> len is size_t but this function returns off64_t, so if src happened to
> be larger than 4GB on a 32-bit system we'll just rip the upper bits off
> the number and use that as the file size.
> 
> Granted I don't know that we care about 32-bit systems.
> 
>> +		if (len < 0) {
> 
> But that doesn't fix the problem, because len is size_t, which is
> unsigned, so this test is never true.
> 
>> +			close(fd);
>> +			return 0;
>> +		}
>>  		copy_dst_truncate();
> 
> Ugh, nobody checked the return value of copy_dst_truncate, so if we
> can't truncate the destination file we just ignore that and keep
> going...
> 
>>  	}
> 
> ...totally untested patch fixing all that nonsense below.
> 
> --D
> 
> From: Darrick J. Wong <darrick.wong@oracle.com>
> Subject: [PATCH] xfs_io: actually check copy file range helper return values
> 
> We need to check the return value of copy_src_filesize and
> copy_dst_truncate because either could return -1 due to fstat/ftruncate
> failure.
> 
> Fixes: 628e112afdd98c5 ("xfs_io: implement 'copy_range' command")
> Cc: schumaker.anna@gmail.com
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  io/copy_file_range.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/io/copy_file_range.c b/io/copy_file_range.c
> index 4e2969c9..ed6fafb1 100644
> --- a/io/copy_file_range.c
> +++ b/io/copy_file_range.c
> @@ -120,11 +120,26 @@ copy_range_f(int argc, char **argv)
>  		return 0;
>  
>  	if (src == 0 && dst == 0 && len == 0) {
> -		len = copy_src_filesize(fd);
> -		copy_dst_truncate();
> +		off64_t	sz;
> +
> +		sz = copy_src_filesize(fd);
> +		if (sz < 0) {
> +			ret = sz;

urgh this is the "what do we return in xfs_io functions?" dilemma,
but every other failure in this function returns 0 to the caller...


> +			goto out;
> +		}
> +		if ((unsigned long)sz > SIZE_MAX) {

as mentioned on IRC this still has the same truncation
problem on a 32-bit box.

-Eric

> +			ret = -EOVERFLOW;
> +			goto out;
> +		}
> +		len = sz;
> +
> +		ret = copy_dst_truncate();
> +		if (ret < 0)

ditto here, ret -1 or 0?

> +			goto out;
>  	}
>  
>  	ret = copy_file_range_cmd(fd, &src, &dst, len);
> +out:
>  	close(fd);
>  	return ret;
>  }
> 
