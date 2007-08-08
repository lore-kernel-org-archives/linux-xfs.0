Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 13:29:06 -0700 (PDT)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de [85.214.69.204])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78KSvbm030959
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 13:28:59 -0700
Date: Wed, 8 Aug 2007 22:05:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [fuse-devel] [PATCH 00/25] move handling of setuid/gid bits from
 VFS into individual setattr functions (RESEND)
In-Reply-To: <20070808094853.8c27450c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708082204210.10387@fbirervta.pbzchgretzou.qr>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
 <20070807171501.e31c4a97.akpm@linux-foundation.org> <20070808085435.722f2b10.jlayton@redhat.com>
 <20070808094853.8c27450c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Layton <jlayton@redhat.com>, codalist@TELEMANN.coda.cs.cmu.edu, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz, reiserfs-devel@vger.kernel.org, zippel@linux-m68k.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, wli@holomorphy.com, joel.becker@oracle.com, dhowells@redhat.com, fuse-devel@lists.sourceforge.net, jffs-dev@axis.com, user-mode-linux-user@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu


On Aug 8 2007 09:48, Andrew Morton wrote:
>> > On Mon, 6 Aug 2007 09:54:03 -0400
>> > Jeff Layton <jlayton@redhat.com> wrote:
>> > 
>> > Is there any way in which we can prevent these problems?  Say
>> > 
>> > - rename something so that unconverted filesystems will reliably fail to
>> >   compile?
>> > 
>> 
>> I suppose we could rename the .setattr inode operation to something
>> else, but then we'll be stuck with it for at least a while. That seems
>> sort of kludgey too...
>
>Sure.  We're changing the required behaviour of .setattr.  Changing its
>name is a fine and reasonably reliable way to communicate that fact.

Maybe ->chattr/->chgattr?


	Jan
-- 
