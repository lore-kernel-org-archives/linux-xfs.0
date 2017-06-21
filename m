Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751265AbdFUWX4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Jun 2017 18:23:56 -0400
Subject: Re: [PATCH] xfsprogs: new libxfs-apply option for Signed-off-by: tag
References: <09b8530a-6b35-bc05-130e-6dfd35889f2b@redhat.com>
 <20170621222059.GT4733@birch.djwong.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a8d38a77-4565-8901-1ae2-dbfcc94e041e@redhat.com>
Date: Wed, 21 Jun 2017 17:23:55 -0500
MIME-Version: 1.0
In-Reply-To: <20170621222059.GT4733@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 6/21/17 5:20 PM, Darrick J. Wong wrote:
> On Thu, May 11, 2017 at 02:35:43PM -0500, Eric Sandeen wrote:
>> Technically when a maintainer moves a patch from another project,
>> they should add their Signed-off-by: tag.  Add an option to
>> libxfs-apply to make that easy when cross-porting libxfs
>> patches.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
>> index e7d7e0a..b594ccb 100755
>> --- a/tools/libxfs-apply
>> +++ b/tools/libxfs-apply
>> @@ -8,7 +8,7 @@ usage()
>>  	echo $*
>>  	echo
>>  	echo "Usage:"
>> -	echo "	libxfs-apply [--verbose] --source <repodir> --commit <commit_id>"
>> +	echo "	libxfs-apply [--verbose] --sob <name/email> --source <repodir> --commit <commit_id>"
>>  	echo "	libxfs-apply --patch <patchfile>"
>>  	echo
>>  	echo "libxfs-apply should be run in the destination git repository."
>> @@ -73,6 +73,7 @@ while [ $# -gt 0 ]; do
>>  	--source)	REPO=$2 ; shift ;;
>>  	--patch)	PATCH=$2; shift ;;
>>  	--commit)	COMMIT_ID=$2 ; shift ;;
>> +	--sob)		SIGNED_OFF_BY=$2 ; shift ;;
> 
> I wonder, under what circumstances does the user /not/ want to have
> their S-o-b added to the commit?  It seems to me that this ought to be
> the default, since the $maintainer is importing code from another
> libxfs, which (to me anyway) doesn't seem all that different from
> pulling in regular patches from the mailing list or wherever.
> 
> Second, can we just pull the name and email from the output of git
> config --get user.{name,email} unless the user explicitly provided a sob
> line?

<shakes fist>

yes that's a good idea :)

>>  	--verbose)	VERBOSE=true ;;
>>  	*)		usage ;;
>>  	esac
>> @@ -274,6 +275,14 @@ fixup_header_format()
>>  			print $0
>>  		}' > $_hdr.new
>>  
>> +	# Remove the last line if it contains only whitespace
>> +	sed -i '${/^ *$/d;}' $_hdr.new
>> +
>> +	# Add Signed-off-by: header if specified
>> +	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
>> +		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
>> +	fi
> 
> Third, we could detect that the patch already has the particular S-o-b
> that we'd be adding here, and avoid adding a duplicate.

hm.  well, I /always/ add mine at the end when I merge it.  So even if
it's like this in the kernel:

Signed-off-by: Bob
Reviewed-by: Alice

if Bob commits it to userspace, I'd still suggest that 
we should end up with:

Signed-off-by: Bob
Reviewed-by: Alice
Signed-off-by: Bob

because it got moved again...

> --D
> 
>> +
>>  	# now output the new patch
>>  	cat $_hdr.new $_diff
>>  
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

