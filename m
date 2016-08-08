Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 71B7D7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 12:29:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36C3F8F8033
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 10:29:06 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id bWf4PumQeJCXtB1M (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2016 10:29:04 -0700 (PDT)
Date: Mon, 8 Aug 2016 10:28:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/17] reflink: test cross-mountpoint reflink and dedupe
Message-ID: <20160808172859.GB11291@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914485237.11762.2526971565060691741.stgit@birch.djwong.org>
	<20160808075601.GA27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160808075601.GA27776@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 08, 2016 at 03:56:01PM +0800, Eryu Guan wrote:
> On Thu, Jul 21, 2016 at 04:47:32PM -0700, Darrick J. Wong wrote:
> > Test sharing blocks via reflink and dedupe between two different
> > mountpoints of the same filesystem.  This shouldn't work, since
> > we don't allow cross-mountpoint functions.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> 
> I added "_supported_fs generic"
> 
> > +_require_scratch_reflink
> > +_require_cp_reflink
> 
> > +
> > +filter_md5() {
> 
> and move "{" to a new line. Also made the same changes to 928 and queued
> the patch up.

Ok, thx. :)

--D

> 
> Thanks,
> Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
