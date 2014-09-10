Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D350B7F56
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:24:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DCB4AC004
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:24:07 -0700 (PDT)
Received: from mail01.lsn.net (mail01.lsn.net [66.90.130.120]) by cuda.sgi.com
	with ESMTP id LJHsYiVMFOrgW0Xr for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 18:24:06 -0700 (PDT)
Message-ID: <540FA827.3090308@mygrande.net>
Date: Tue, 09 Sep 2014 20:23:51 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>	<540F7E37.7020500@sandeen.net>	<CAA43vkX8Ve3g7=w16742b4vT3=yRdCMR7m66g2M7fYPmEMmctA@mail.gmail.com>
	<62B15E94-1944-457F-B298-89EDEE3EC70D@filmlight.ltd.uk>
In-Reply-To: <62B15E94-1944-457F-B298-89EDEE3EC70D@filmlight.ltd.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Roger Willcocks <roger@filmlight.ltd.uk>, Sean Caron <scaron@umich.edu>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/9/2014 8:00 PM, Roger Willcocks wrote:
> I normally watch quietly from the sidelines but I think it's important
> to get some balance here

	That is almost always wise advice.  Shooting from the hip often has 
regrettable consequences, yet being too cautious can have its down side, 
too.  In this case, things are working very well at the moment, and the 
apparent issues are reasonably small, so there is no need for panic.

> our customers between them run many hundreds
> of multi-terabyte arrays and when something goes badly awry it generally
> falls to me to sort it out. In my experience xfs_repair does exactly
> what it says on the tin.

	I couldn't say.  This is only the second time I have ever had an array 
drop, and the first time it was completely unrecoverable.  Less than 5 
minutes after I had started a RAID upgrade from RAID5 to RAID6, there 
was a protracted power outage.  I shut down the system cleanly and after 
the outage restarted the reshape.  The recovery had only been running a 
few minutes when the system suffered a kernel panic - I never did find 
out why.  Every single structure on the array larger than the stripe 
size (16K, I think) was garbage.

> I can recall only a couple of instances where we elected to reformat and
> reload from backups and they were both due to human error: somebody
> deleted the wrong raid unit when doing routine maintenance, and then
> tried to fix it up hemselves.
>
> In theory of course xfs_repair shouldn't be needed if the write barriers
> work properly (it's a journalled filesystem), but low-level corruption
> does creep in due to power failures / kernel crashes and it's this which
> xfs_repair is intended to address; not massive data corruption due to
> failed hardware or careless users.

	Oh, yeah, like losing 3 out of 8 drives in the array after a drive 
controller replacement...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
