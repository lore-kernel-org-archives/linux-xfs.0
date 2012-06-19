Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JG3966117296 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 11:03:09 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9MweSYWL1lHUOddl for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:03:08 -0700 (PDT)
Date: Tue, 19 Jun 2012 17:03:01 +0100
From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Ext4 and xfs problems in dm-thin on allocation and
	discard
Message-ID: <20120619160300.GF14208@agk-dp.fab.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org>
	<alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
	<20120619141933.GC10637@thunk.org>
	<20120619144316.GD14208@agk-dp.fab.redhat.com>
	<20120619152856.GB7225@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120619152856.GB7225@redhat.com>
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

On Tue, Jun 19, 2012 at 11:28:56AM -0400, Mike Snitzer wrote:
> That is an lvm2 BZ but there is further kernel work needed.
 
In principle, userspace should already be able to handle the replumbing I
think.  (But when we work through the details of an online import, perhaps
we'll want some further kernel change for atomicity/speed reasons?  In 
particular we need to be able to do the last part of the metadata merge
quickly.)

Roughly:
1. rejig the lvm metadata for the new configuration [lvm]
  - appends the "whole LV" data to the pool's data
2. Generate metadata for the appended data and append this to the metadata area [dmpd]
3. suspend all the affected devices [lvm]
4. link the already-prepared metadata into the existing metadata [dmpd]
5. resume all the devices (now using the new extended pool)

Alasdair

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
