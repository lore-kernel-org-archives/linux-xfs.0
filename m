Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBEBE7F62
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 01:19:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47674AC002
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 23:19:37 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id FNPuMUz6iAXVvXEG
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 23:19:36 -0700 (PDT)
Message-ID: <5148037B.5010706@hardwarefreak.com>
Date: Tue, 19 Mar 2013 01:19:39 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
	<5147E360.10605@sandeen.net>
In-Reply-To: <5147E360.10605@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On 3/18/2013 11:02 PM, Eric Sandeen wrote:
> On 3/17/13 6:42 AM, Subranshu Patel wrote:
>>
>> In case of EXT4, journal will not be replayed on performing mount.
>> One need to invoke fsck which performs journal playback and then
>> other corruption checks/recovery. Correct me if I am wrong.
> 
> You are wrong, I'm afraid.

Eric he misunderstood what I stated previously, and mangled repeating it.

> Simple tests, or reading the code, will show you that ext4
> replays a dirty log at mount time.

What I stated was that EXT4 makes a call to user space e2fsck to execute
the journal replay routine.  If this code is duplicated in the EXT4
kernel driver, then my apologies for spreading misinformation due to
being misinformed.  I'm not a programmer and have not read the code, and
wouldn't understand it if I did.

I've never used EXT3/4.  Thus I Googled extensively for "ext4 journal
recovery" and the like before making my statement specifically to avoid
a misstatement of fact.  30+ minutes wasted apparently...  Everything I
found indicated that the mechanism for journal playback was the journal
code in e2fsck.  And not finding any mention of journal recovery code in
the kernel in these hits, I thought I had correct information.

I use rolled kernels that don't have module support, and they don't have
the EXT4 driver built in, only XFS.  So even if I'd thought of it I
couldn't perform the USB test Martin mentioned and verify if the user
space call was made or not.  And after what Google told me, I simply
didn't consider the information to be incorrect or incomplete, so I
didn't think to build a rig and test it.

Martin, I didn't state that ext4 cannot perform journal recovery, which
you previously misunderstood.  As mentioned above I stated it made a
call to e2fsck to perform the task.  And, again, apparently this is not
the case.  If you want to excoriate me for getting this wrong, that's
fine.  But don't do it in a way that suggests it was intentional, or
that I made no effort to verify the information before I stated it.  I
spent at least 30 minutes Googling trying to track down documents
explaining the ext4 journal recovery code in the kernel.  I simply
didn't find any.  The only thing I found were descriptions of e2fsck
based journal recovery.

If someone has a link to a document describing the ext4 journal recovery
code I'd love to read it, so I can speak more intelligently about it in
the future.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
