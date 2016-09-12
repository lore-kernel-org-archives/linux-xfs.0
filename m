Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 856637CA0
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 13:41:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 494D78F8033
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 11:41:28 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AvdgyylHW5sTDrvi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Sep 2016 11:41:25 -0700 (PDT)
Date: Mon, 12 Sep 2016 11:40:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/71] xfs: log refcount intent items
Message-ID: <20160912184054.GA23422@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216802075.867.12945255918683675311.stgit@birch.djwong.org>
	<20160906152155.GJ24287@infradead.org>
	<20160908191404.GB8969@birch.djwong.org>
	<20160908231326.GA30056@dastard>
	<20160908231656.GC8969@birch.djwong.org>
	<20160911125246.GA1399@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160911125246.GA1399@infradead.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Sun, Sep 11, 2016 at 05:52:46AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 08, 2016 at 04:16:56PM -0700, Darrick J. Wong wrote:
> > > Carfeul there - enums are not defined to have a fixed size and so
> > > can change from compiler version to compiler version. IOWs, the
> > > enum values can be written idirectly to an on-disk structure, but
> > > the on-disk structure should not be using the enum as the type
> > > definition for whatever gets stored on disk.
> > 
> > <nod>  I left the fields (and the #define flags) definitions alone,
> > so it's only writing enum values indirectly into a fixed size (u32)
> > variable on-disk.
> > 
> > i.e. I'm not using enums in the on-disk structure definitions.
> 
> now add a byte swap for the flags and everything should be fine.
> The whole idea of architecture-dependent log items was a horrible
> idea, and I still have hopes of fixing it eventually.

There are other fields in the CUI/BUI log items that would also
need byte swapping.  Not so hard to fix now, though fixing the
EFI/RUI/everythingelse will have to be part of that future patchset.

<shrug> I also have a vague memory of Dave telling me not to worry
about making the log item fields arch-independent...

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
