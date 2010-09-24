Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ODHs7i183443 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:17:54 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70620E53478
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:31:27 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id jEWhX4CJgwWtzmKE for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 06:31:27 -0700 (PDT)
Date: Fri, 24 Sep 2010 15:18:46 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100924151846.1208611c@harpe.intellique.com>
In-Reply-To: <20100924075505.GA24664@infradead.org>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: 'Ryszard Stawiarski' <ryszard.stawiarski@open-e.com>, ??ukasz Wittig <lukasz.wittig@open-e.com>, Artur Piechocki <artur.piechocki@open-e.com>, xfs@oss.sgi.com, Slawomir Nowakowski <slawomir.nowakowski@open-e.com>

Le Fri, 24 Sep 2010 03:55:05 -0400
Christoph Hellwig <hch@infradead.org> =E9crivait:

> Thanks, I know ISCSI very well.  But what is "iSCSI FileIO" ?  The
> above sounds like it's an iscsi target, is that correct?

It's an IO Mode that goes through the kernel VFS cache, as opposed to
blockIO that does direct IO.

> I still can't make any sense of the actual setups.
> =

> The above seems to be the backend storage.  Then there's SCST
> somewhere in which is in a out of tree kernel module.  And then you
> use XFS somewhere.  Please provide a full description of the setup.

If the iSCSI targets are actually block devices (lvm lvs, disk
partitions, etc), than using FileIO is a mistake, it may bring up all
kind of weird behaviours, though normally no real errors - though I
don't really know how scst fares in this regard.

My understanding : he planned to create a file on the mounted XFS
volume with dd but instead he dd'ed the lv itself, which obviously
destroyed the filesystem. Or something else, I don't really know :)

Slawomir, please show us the scst config file. Did you use mkfs
and dd on the target or the initiator? This isn't clear.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
