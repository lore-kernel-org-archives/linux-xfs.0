Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JEhPmt105851 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:43:25 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EBkR7fWI6S8FQ5Hi for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:43:24 -0700 (PDT)
Date: Tue, 19 Jun 2012 15:43:16 +0100
From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Ext4 and xfs problems in dm-thin on allocation and
	discard
Message-ID: <20120619144316.GD14208@agk-dp.fab.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
	<alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
	<20120619141933.GC10637@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619141933.GC10637@thunk.org>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, Spelic <spelic@shiftmail.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 19, 2012 at 10:19:33AM -0400, Ted Ts'o wrote:
> One of the things which would be nice to be able to easily set up is a
> configuration where we get the benefits of thin provisioning with
> respect to snapshost, but where the underlying block device used by
> the file system is contiguous.  

We're tracking this requirement (for lvm2) here:
  https://bugzilla.redhat.com/show_bug.cgi?id=814737

Alasdair

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
