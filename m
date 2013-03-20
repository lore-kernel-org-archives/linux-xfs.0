Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79BB07F4E
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 09:37:13 -0500 (CDT)
Message-ID: <5149C9B9.2060900@sgi.com>
Date: Wed, 20 Mar 2013 09:37:45 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Count journal size in test 289
References: <1363776648-14061-1-git-send-email-jack@suse.cz>
	<5149C824.8070300@sandeen.net>
In-Reply-To: <5149C824.8070300@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On 03/20/2013 09:31 AM, Eric Sandeen wrote:
> On 3/20/13 5:50 AM, Jan Kara wrote:
>> Test 289 ignored the fact that historically journal is not accounted as
>> fs overhead in ext3. For larger filesystems it is hidden in 1% tolerance
>> but for filesystems smaller than 12G the test fails. So make the
>> counting precise to work everywhere.
>>
>> CC: Eric Sandeen <sandeen@sandeen.net>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>
> Looks fine, thanks.
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>
>
> p.s. - sorry, didn't catch this the first time:
>
> _filter_size_to_bytes won't work for lowercase units, which might
> be nice.  How about:
>
>> +	case $suffix in
>> +		k|K) mul=1024 ;;
>> +		m|M) mul=$((1024*1024)) ;;
>> +		g|G) mul=$((1024*1024*1024)) ;;
>> +		t|T) mul=$((1024*1024*1024*1024)) ;;
>> +	esac
>
> SGI guys - maybe could do that as a small fix-up on commit.  Otherwise, if anyone
> ever needs lower case they could just add it at the same time, so no big deal.

Will do thanks for the review.

--Rich

>
> -Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
