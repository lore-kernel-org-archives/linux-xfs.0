Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 12 Sep 2008 01:45:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8C8jchF009494
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 01:45:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 579DF431EC9
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 01:47:07 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Mcgbwl0iHFj6iBKR for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 01:47:07 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m8C8l7IF023204
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2008 10:47:07 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m8C8l7vG023202
	for xfs@oss.sgi.com; Fri, 12 Sep 2008 10:47:07 +0200
Date: Fri, 12 Sep 2008 10:47:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use generic_file_llseek for directories
Message-ID: <20080912084707.GB22641@lst.de>
References: <20080814204817.GA19614@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814204817.GA19614@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Aug 14, 2008 at 10:48:17PM +0200, Christoph Hellwig wrote:
> XFS currently doesn't set up a .llseek for directories and thus defaults
> to default_llseek.  default_llseek only takes the BKL which means there
> is not exclusion vs xfs_readdir and thus we get a risk of corrupting
> the file position.  Additionally default_llseek only allows seeks to
> 32bit offsets by default.

Al put this change into mainline as part of fixing up various
filesystems in the meantime.
