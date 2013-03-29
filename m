Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B7C27F98
	for <xfs@oss.sgi.com>; Fri, 29 Mar 2013 15:27:39 -0500 (CDT)
Date: Fri, 29 Mar 2013 15:27:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Help with XFS in VMs on VMFS
Message-ID: <20130329202735.GX22182@sgi.com>
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
	<51549F09.1090109@hardwarefreak.com>
	<20130328214550.GA3771@pirx.askja.de>
	<5154E6AC.9020402@hardwarefreak.com>
	<CAJoqCq_afu4d++fgkGGMDC55pcz62V3qyai906ihQ2d=eiyhhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJoqCq_afu4d++fgkGGMDC55pcz62V3qyai906ihQ2d=eiyhhQ@mail.gmail.com>
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
To: Jan Perci <jperci@gmail.com>
Cc: xfs@oss.sgi.com

Hi Jan,

On Thu, Mar 28, 2013 at 11:30:01PM -0400, Jan Perci wrote:
> Back to XFS, in this context, is there any benefit in tuning some
> parameters to get better performance, or will it all just be overshadowed
> by poor performance of the VMDKs that tuning isn't worthwhile?

At least get your stripe unit and width correct.
http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance

Beyond that I suggest you stick with the defaults unless you have a specific
need.  e.g. heavy usage of extended attributes might prompt you to use a larger
inode size to keep them inline.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
