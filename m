Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B6E6E7FAD
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 13:44:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 949ED8F8039
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 11:44:18 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id rH2k1D3UyftFrcNO
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 18 Feb 2014 11:44:13 -0800 (PST)
Received: from localhost (al.wesleyan.edu [129.133.22.76])
	(authenticated bits=0)
	by msa.wesleyan.edu (8.14.4/8.14.4) with ESMTP id s1IJiBKj019474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 14:44:12 -0500
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
In-reply-to: <52F09E36.8050606@hardwarefreak.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <52E91923.4070706@sandeen.net>
	<1391022066-sup-5863@al.wesleyan.edu>
	<52E99504.4030902@hardwarefreak.com>
	<1391090527-sup-4664@al.wesleyan.edu>
	<20140130202819.GO2212@dastard>
	<52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
	<20140202212152.GP2212@dastard>
	<1391443675-sup-1730@al.wesleyan.edu>
	<20140203214128.GR13997@dastard>
	<52F09E36.8050606@hardwarefreak.com>
Date: Tue, 18 Feb 2014 14:44:10 -0500
Message-Id: <1392748390-sup-1943@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs <xfs@oss.sgi.com>

Howdy, sorry for digging up this thread, but I've run into an issue
again, and am looking for advice.

Excerpts from Stan Hoeppner's message of 2014-02-04 03:00:54 -0500:
> After a little digging and thinking this through...
> 
> The default PE size is 4MB but up to 16GB with LVM1, and apparently
> unlimited size with LVM2.  It can be a few thousand times larger than
> any sane stripe width.  This makes it pretty clear that PEs exist
> strictly for volume management operations, used by the LVM tools, but
> have no relationship to regular write IOs.  Thus the PE size need not
> match nor be evenly divisible by the stripe width.  It's not part of the
> alignment equation.

So in the course of actually going about this, I realized that this
actually is not true (I think).

Logical volumes can only have sizes that are multiple of the physical
extent size (by definition, really), and so there's no way to have
logical volumes end on a multiple of the array's stripe width, given my
stripe width of 9216s, there doesn't seem to be an abundance of integer
solutions to 2^n mod 9216 = 0.

So my question is, then, does it matter if logical volumes (or, really,
XFS file systems) actually end right on a multiple of the stripe width,
or only that it _begin_ on a multiple of it (leaving a bit of dead space
before the next logical volume)?

If not, I'll tweak things to ensure my stripe width is a power of 2.

Thanks again!
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
