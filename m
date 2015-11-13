Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54B7F7F6C
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 03:08:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE1C1AC001
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 01:08:55 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id kMlMoCTw57lyxGwI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 01:08:54 -0800 (PST)
Date: Fri, 13 Nov 2015 01:08:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20151113090822.GB2214@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
	<20151112090756.GA25685@infradead.org>
	<20151112125115.GA28822@infradead.org>
	<20151112173427.GC2217@birch.djwong.org>
	<20151112173635.GA9247@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151112173635.GA9247@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Thu, Nov 12, 2015 at 09:36:35AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 12, 2015 at 09:34:27AM -0800, Darrick J. Wong wrote:
> > Bleargh, _require_*_dedupe forgot to check for ENOTTY output, so all the dedupe
> > tests should have _notrun.
> > 
> > Also, generic/806 was calling the wrong _require.
> > 
> > I'll start renumbering tests; Christoph, did you see anything else?
> 
> Looks fine so far otherwise.

I think I got all the tests renumbered correctly and fixed all the other bugs.
I'd like to send the updated patchpile to Dave tomorrow, but if you have a few
spare cycles would you mind giving this a quick test to make sure I fixed
everything?

https://github.com/djwong/xfstests/tree/for-dave

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
