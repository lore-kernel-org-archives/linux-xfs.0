Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F30B67F37
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 12:49:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8AAD0AC003
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 10:49:24 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wriDWIg3IpwcvTrk (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 10:49:23 -0700 (PDT)
Date: Tue, 24 Mar 2015 10:49:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
Message-ID: <20150324174916.GA28906@infradead.org>
References: <20150318205554.GA10716@fieldses.org> <5509E824.6070006@Netapp.com>
	<20150318211144.GB10716@fieldses.org>
	<OFB111A6D8.016B8BD5-ON88257E0D.001D174D-88257E0D.005268D6@us.ibm.com>
	<20150319153627.GA20852@fieldses.org>
	<OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
	<20150320151718.GD2036@fieldses.org>
	<20150320162303.GA18786@infradead.org>
	<20150320182621.GH2036@fieldses.org>
	<CAFX2JfkybBPcqD6A8r-jOkPnkL26=NEuK3zhA6TLn-DVam+kfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFX2JfkybBPcqD6A8r-jOkPnkL26=NEuK3zhA6TLn-DVam+kfQ@mail.gmail.com>
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
To: Anna Schumaker <anna.schumaker@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Marc Eshel <eshel@us.ibm.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs-owner@vger.kernel.org

On Tue, Mar 24, 2015 at 08:43:31AM -0400, Anna Schumaker wrote:
> > I don't know, and don't have profiles.  I'll either try to reproduce or
> > wait till Anna's back from vacation.
> 
> I'm using whatever functions NFSD already uses for reading files,
> which I expect go through the VFS.  Is there a flag that controls
> cache behavior?

There's the O_DIRECT flag, but that's not what I mean.  If you just
wrote to it it's a cached read, if you did unmount the filesystem after
writing, or did an echo to /proc/sys/vm/drop_caches you get uncached
read behavior.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
