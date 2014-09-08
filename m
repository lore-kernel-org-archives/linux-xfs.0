Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC5F77F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 22:18:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A64AAC004
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 20:18:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Mh3XGqy4WvM6hBgz for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 20:18:09 -0700 (PDT)
Message-ID: <540D1FF1.4030601@sandeen.net>
Date: Sun, 07 Sep 2014 22:18:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs_repair: don't ASSERT on corrupt ftype
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-5-git-send-email-sandeen@redhat.com>
	<20140908001044.GB30012@dastard> <540D001C.6020607@sandeen.net>
	<20140908031644.GZ20518@dastard>
In-Reply-To: <20140908031644.GZ20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On 9/7/14 10:16 PM, Dave Chinner wrote:
> On Sun, Sep 07, 2014 at 08:02:20PM -0500, Eric Sandeen wrote:
>> On 9/7/14 7:10 PM, Dave Chinner wrote:

...

>>> Needs to be fixed kernel-side first.
>>
>> xfs_dir3_dirent_get_ftype doesn't exist in kernelspace :)
>>
>> bleah, why do they have different names...  Ok, will send.
>
> Because kernel has changed, and we need to do yet another large
> kernel/user libxfs sync.
>
> I haven't found time to do that yet. Unless you want to volunteer
> for it....

I could give it a shot.  Do you usually do it commit-by-commit,
diff-and-edit, or a big copy?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
