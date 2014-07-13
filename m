Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E652F7F61
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 03:57:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A855E304032
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 01:57:09 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id 67Em1L6ExtDKEwLX (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 13 Jul 2014 01:57:07 -0700 (PDT)
Subject: Bug#751511: xfslibs-dev: Incorrect licensing information in
	debian/copyright
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.751511.B751511.140524158822254@bugs.debian.org>
Date: Sun, 13 Jul 2014 01:33:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20140713083336.GA24104@infradead.org>
References: <20140613142534.8854.10300.reportbug@sibsagar.btc.netapp.com>
	<20140613152414.GF2840@sid.nuvreauspam>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140613152414.GF2840@sid.nuvreauspam>
Reply-To: Christoph Hellwig <hch@infradead.org>, 751511@bugs.debian.org
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
To: Andrei POPESCU <andreimpopescu@gmail.com>
Cc: 751511@bugs.debian.org, Y Giridhar Appaji Nag <appaji@debian.org>, xfslibs-dev@packages.debian.org

On Fri, Jun 13, 2014 at 06:24:14PM +0300, Andrei POPESCU wrote:
> Control: reassign -1 xfslibs-dev
> 
> On Vi, 13 iun 14, 19:55:34, Y Giridhar Appaji Nag wrote:
> > Source: xfslibs-dev
> > Severity: serious
> > Justification: Policy 4.5
> > 
> > It looks like the xfslibs-dev package source files are licensed under LGPL
> > v2.1, however the debian/copyright file indicates that only the libhandle
> > package is under LGPL and that the rest of the package is licensed under GPL.

All the headers in xfslibs-dev are licensed under the LGPL.  The man
pages don't have specific licensing information in the source file nad
thus default to GPL.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
