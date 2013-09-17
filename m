Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 341D07F4E
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 19:54:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2275C30404E
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 17:54:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id u1fnYcJx0ABadGGv for <xfs@oss.sgi.com>;
	Mon, 16 Sep 2013 17:54:40 -0700 (PDT)
Message-ID: <5237A84E.2010404@sandeen.net>
Date: Mon, 16 Sep 2013 19:54:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfstests: add d_type checking to fsstress
References: <52377E50.3040907@redhat.com> <20130916225550.GG19103@dastard>
In-Reply-To: <20130916225550.GG19103@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 9/16/13 5:55 PM, Dave Chinner wrote:
> On Mon, Sep 16, 2013 at 04:55:28PM -0500, Eric Sandeen wrote:
>> This patch adds a "-D" switch to fsstress so that every time
>> we call readdir, we stat the dentry & compare it's st_mode
>> to the d_type.
>>
>> If -D is specified only once, it ignores DT_UNKNOWN.  If specified
>> twice, it considers DT_UNKNOWN to be an error.
> 
> Hmmmm. DT_UNKNOWN is actually a valid type on disk right through to the
> userspace interface. I can't think of why we'd want to consider it
> invalid, especially as right now xfs_repair siply zeros the field
> when recreating directory entries...
> 
> Cheers,
> 
> Dave.

 no fair signing off w/ more text below ;)

>> +void test_d_type(int opno, pathname_t *f, struct dirent64 *de)
>> +{
>> +	struct stat64 sb;
>> +	char path[PATH_MAX];
>> +
>> +	snprintf(path, PATH_MAX, "%s/%s", f->path, de->d_name);
>> +
>> +	/* Don't check ./. or ./.. */
>> +	if (!strncmp(path, "./.", 3))
>> +		return;
> 
> . and .. should have the values of DT_UNKNOWN or DT_DIR. They are
> the only valid values for these entries.

Hm let me look at something, I saw something that prompted this
but now that I think about it maybe it's a bug.

>> +
>> +	if (lstat64(path, &sb)) {
>> +		printf("%d/%d: getdents - can't stat %s\n",
>> +			procid, opno, path);
>> +	} else {
>> +		int bad_d_type = 0;
>> +
>> +		switch (de->d_type) {
>> +			case DT_BLK:
>> +				if (!S_ISBLK(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_CHR:
>> +				if (!S_ISCHR(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_DIR:
>> +				if (!S_ISDIR(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_FIFO:
>> +				if (!S_ISFIFO(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_LNK:
>> +				if (!S_ISLNK(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_REG:
>> +				if (!S_ISREG(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_SOCK:
>> +				if (!S_ISSOCK(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_UNKNOWN:
>> +				if (verify_d_type > 1)
>> +					bad_d_type++;
>> +			break;
>> +		}
> 
> And DT_WHT? That's defined on disk and in the user interface ;)

but fsstress won't create it, will it?
 
> i.e. this will not do the right thing with an unknown de->d_type.

... but we know what fsstress can possibly create, right, so testing
those created types should be safe, I'd think.

I'll give this some thought & send V2.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
