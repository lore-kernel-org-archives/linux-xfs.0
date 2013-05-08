Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3276429E12
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 19:44:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 237C230406A
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 17:43:57 -0700 (PDT)
Date: Tue, 7 May 2013 20:43:50 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130508004350.GA19136@redhat.com>
References: <518954DE.4070803@sgi.com> <20130507193146.GA7539@redhat.com>
	<51895CD7.7040806@sgi.com> <20130507195954.GA8384@redhat.com>
	<51895E51.2050508@sgi.com> <20130507202217.GA9883@redhat.com>
	<518962FC.2060509@sgi.com> <20130507222256.GD24635@dastard>
	<51898400.8000900@sgi.com> <20130507235458.GG24635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130507235458.GG24635@dastard>
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
Cc: xfs@oss.sgi.com, Mark Tinguely <tinguely@sgi.com>, CAI Qian <caiqian@redhat.com>

On Wed, May 08, 2013 at 09:54:58AM +1000, Dave Chinner wrote:
 > Dave, the patch below should fix the problem.
 > 
 > xfs: Don't reference the EFI after it is freed
 > 
 > From: Dave Chinner <dchinner@redhat.com>
 > 
 > Checking the EFI for whether it is being released from recovery
 > after we've already released the known active reference is a mistake
 > worthy of a brown paper bag. Fix the (now) obvious use after free
 > that it can cause.

Yup, that works for me.

thanks,

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
