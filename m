Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C8E47F50
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 14:07:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B46A304048
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 12:07:38 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	WBDjHUnIOzWVtCY9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 Jul 2014 12:07:33 -0700 (PDT)
Received: by mail-wi0-f179.google.com with SMTP id f8so1332329wiw.12
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 12:07:32 -0700 (PDT)
Received: from teal.hq.k1024.org (178-83-234-80.dynamic.hispeed.ch.
	[178.83.234.80]) by mx.google.com with ESMTPSA id
	v14sm16212728wjw.38.2014.07.18.12.07.31 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Fri, 18 Jul 2014 12:07:31 -0700 (PDT)
Date: Fri, 18 Jul 2014 21:07:30 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: xfsrestore -t and default location of housekeeping dir
Message-ID: <20140718190730.GA27801@teal.hq.k1024.org>
References: <20140714071935.GB29541@teal.hq.k1024.org>
	<20140717090550.GB27425@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140717090550.GB27425@infradead.org>
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
To: xfs@oss.sgi.com

On Thu, Jul 17, 2014 at 02:05:50AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 14, 2014 at 09:19:35AM +0200, Iustin Pop wrote:
> > Hi,
> > 
> > While testing a just-made dump with via 'xfsrestore -t', I learned that
> > the default housekeepingdir path is still under the original filesystem.
> > My xfsrestore therefore failed, since that filesystem was read-only.
> > 
> > Since '-t' should denote a pure no-op operation, with no changes, would
> > it make more sense to default the housekeeping location to a temporary
> > location if it is used?
> 
> It seems to me like -t shouldn't recreate the files in the housekeeping
> directory at all.  I did take a brief look at the code and is a huge
> mess that seems to recreate files unconditionally, so I don't really
> have a good solution for this yet.

Understood. Thanks!

iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
