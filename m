Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6AL27vR122213 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 16:02:08 -0500
Received: from mail-bw0-f214.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A55A41BD34C1
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 14:02:43 -0700 (PDT)
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214]) by cuda.sgi.com with ESMTP id
	QMMvZT0VMGpSLANh for <xfs@oss.sgi.com>;
	Fri, 10 Jul 2009 14:02:43 -0700 (PDT)
Received: by bwz10 with SMTP id 10so952692bwz.20
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 14:02:41 -0700 (PDT)
Message-ID: <4A57AC69.7070502@gmail.com>
Date: Fri, 10 Jul 2009 23:02:33 +0200
From: Tomek Kruszona <bloodyscarion@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com> <4A56D176.9010702@sandeen.net>
	<4A56ED5F.10400@gmail.com> <4A57A1C4.40004@sandeen.net>
In-Reply-To: <4A57A1C4.40004@sandeen.net>
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
To: xfs@oss.sgi.com

Eric Sandeen wrote:
> This looks like some of the caching that xfs_repair does is mis-sized,
> and it gets stuck when it's unable to find a slot for a new node to
> cache.  IMHO that's still a bug that I'd like to work out.  If it gets
> stuck this way, it'd probably be better to exit, and suggest a larger
> hash size.
> 
> But anyway, I forced a bigger hash size:
> 
> xfs_repair -P -o bhash=1024 <blah>
> 
> and it did complete.  1024 is probably over the top, but it worked for
> me on a 4G machine w/ some swap.
:D

Is it safe to use xfs_repair without this options after the FS was
repaired? Or maybe I should use them every time I have similar problem?

> I'd strongly suggest doing a non-obfuscated xfs_metadump, do
> xfs_mdrestore of that to some temp.img, run xfs_repair <blah> on that
> temp.img, mount it, and see what you're left with; that way you'll know
> what you're getting into w/ repair.
> I ended up w/ about 5000 files in lost+found just FWIW...
It doesn't matter. On this filesystem is a lot of small files. Those are
image sequences used for video composition. It's backup machine so if
they're gone from filesystem they will be copied back from original
machine. No stress :)

I'm doing xfs_repair on the image now - it's Phase 4 and for now list of
files looks very similar to list that I saw during xfs_repair without
options you suggested.

> Out of curiosity, do you know how the fs was damaged?
I'm not sure. I see some possibilities. I played with write cache
options on the RAID controller when the FS was mounted and running.
Maybe then something went wrong... Second possible reason is that we had
power loss last time and this machine went down then :/
Last one is that I have some problems with XFS filesytems on LVM2. in
kernels <2.6.30 barriers are automatically disabled when underlying
device is some dm-device. As I'm using RAID controllers I should have
write cache disabled. So after upgrade to 2.6.30 message about disabled
barriers disappeared and it was safe to enable write cache again.
Somewhere in the meantime I wanted to check filesystem that everything
is ok with it and then the problem started - I couldn't finish
xfs_repair. This power loss was IIRC after my troubles with xfs_repair,
so the filesystem wasn't totally clean when power failed. Maybe this is
the reason of this mess ;)

Best regards
Tomasz Kruszona

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
