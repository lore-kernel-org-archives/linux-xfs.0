Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFEA67FAC
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 11:32:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9B1D9304039
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 09:32:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fWmqc7qCVWG1Qz57 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 09:31:59 -0700 (PDT)
Date: Fri, 10 Apr 2015 13:31:51 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: hard reboot, no XFS messages
Message-ID: <20150410163151.GA1017@hades.maiolino.org>
References: <296cad845fb1a5c610adf6d9975d3a95@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <296cad845fb1a5c610adf6d9975d3a95@posteo.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Malte Gell <mailinglisten@posteo.de>
Cc: XFS <xfs@oss.sgi.com>

On Thu, Apr 09, 2015 at 02:52:55AM +0200, Malte Gell wrote:
> Hi there,
> I=B4m totally new to XFS.
> =

> Recently my Linux box was stuck and I had to reboot it hard.
> After the reboot I was surprised, there were no error messages or corrupt
> inodes.
> =

> Usually on my ext4 root partition there are always some damaged inodes th=
at
> get deleted. But my /home XFS partition seemed to have suffered zero effe=
ct
> from cold reboot.
> =

> Is this normal for XFS that a cold reboot is handled that smooth?
> =

> The XFS /home partition was created with Linux kernel 3.16.3.
> =

> The only messages I saw in /var/log/messages was this:
> =

> SGI XFS with ACLs, security attributes, realtime, large block/inode numbe=
rs,
> no debug enabled
> XFS (dm-0): Mounting V4 Filesystem
> XFS (dm-0): Starting recovery (logdev: internal)
> XFS (dm-0): Ending recovery (logdev: internal)
> =

> On the net some people say XFS was very robust, but I did not expect it is
> that smooth after a cold reset... And other people said they were in hell
> with XFS...
> =

> Thanks
> =

Yes, it is normal, welcome to XFS :)
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- =

Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
