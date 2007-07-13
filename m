Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jul 2007 07:28:37 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6DESXbm011413
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 07:28:34 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6DESZ5G015875
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 10:28:35 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6DESZ9M447660
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 10:28:35 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6DESYKj029152
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2007 10:28:35 -0400
Date: Fri, 13 Jul 2007 19:58:51 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/6][TAKE7] revalidate write permissions for fallocate
Message-ID: <20070713142851.GD27291@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124847.GC22961@amitarora.in.ibm.com> <20070713132137.GB23256@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713132137.GB23256@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, tytso@mit.edu, cmm@us.ibm.com, suparna@in.ibm.com, adilger@clusterfs.com, dgc@sgi.com

On Fri, Jul 13, 2007 at 02:21:37PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 13, 2007 at 06:18:47PM +0530, Amit K. Arora wrote:
> > From: David P. Quigley <dpquigl@tycho.nsa.gov>
> > 
> > Revalidate the write permissions for fallocate(2), in case security policy has
> > changed since the files were opened.
> > 
> > Acked-by: James Morris <jmorris@namei.org>
> > Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> 
> This should be merged into the main falloc patch.

Ok. Will merge it...

--
Regards,
Amit Arora
