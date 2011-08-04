Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74MHgFk088782 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 17:17:43 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D398D168ED3A
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2011 15:18:38 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id UsbsWpdDbcA2DyuU for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2011 15:18:38 -0700 (PDT)
Message-ID: <4E3B1A84.10708@sandeen.net>
Date: Thu, 04 Aug 2011 17:17:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: skip over "rootfs" entry if mtab links to
	/proc/mounts
References: <4E399677.1010508@redhat.com>
	<20110803190216.GA31421@infradead.org>
In-Reply-To: <20110803190216.GA31421@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 8/3/11 2:02 PM, Christoph Hellwig wrote:
> On Wed, Aug 03, 2011 at 01:41:59PM -0500, Eric Sandeen wrote:
>> This is for RH bug 727938, xfs_fsr regression for root file system
>>
>> Fedora has made /etc/mtab a symlink to /proc/mounts, but when
>> we issue "xfs_fsr /" and fsr's getmntany() goes looking for
>> the "/" entry, the first one it finds is
>>
>> rootfs / rootfs rw 0 0
>>
>> it says no way, that's a rootfs filesystem type, not xfs!
>> And it never finds this later:
>>
>> /dev/sda2 / xfs rw,relatime,attr2,noquota 0 0
>>
>> This patch to skip over the rootfs entry seems to fix it.
> 
> I don't like this.  rootfs is the symptom, but the underlying problem
> is that in Linux we're perfectly fine to have multiple filesystems
> mounted on a single mountpoint, and the getmntany can't deal with it.
> 
> I think the right fix is to simply remove the break from the loop,

It's not quite that simple.

when we do

	*mp = *t;
	/* break; */

we are pointing the mp string pointers at the strings in the getmntent entry,
which will keep moving as we iterate.  We'll need a strdup or something
to copy it out on each good find, with appropriate frees etc, I guess.

Is there a better way to do it?  This seems pretty ugly.

        memset(mp, 0, sizeof(struct mntent));
        while ((t = getmntent(fp))) {
                if (mpref->mnt_fsname) {        /* device */
                        if (stat64(t->mnt_fsname, &ms) < 0)
                                continue;
                        if (s->st_rdev != ms.st_rdev)
                                continue;
                }
                if (mpref->mnt_dir) {           /* mount point */
                        if (stat64(t->mnt_dir, &ms) < 0)
                                continue;
                        if (s->st_ino != ms.st_ino || s->st_dev != ms.st_dev)
                                continue;
                }
                /* This one matches */
                found = 1;
                free(mp->mnt_fsname);
                free(mp->mnt_dir);
                free(mp->mnt_type);
                mp->mnt_fsname = strdup(t->mnt_fsname);
                mp->mnt_dir = strdup(t->mnt_dir);
                mp->mnt_type = strdup(t->mnt_type);
        }
        return (found);


(and then free the strings in the caller when we're done ...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
