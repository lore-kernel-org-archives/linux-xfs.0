Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Mar 2007 18:04:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2J1496p023688
	for <xfs@oss.sgi.com>; Sun, 18 Mar 2007 18:04:11 -0700
Date: Mon, 19 Mar 2007 12:04:00 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: HAVE_FORMAT32 never enabled in mainline
Message-ID: <EFC23B1F6DEB80902BB22B79@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070317154028.GA18997@lst.de>
References: <20070317154028.GA18997@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, tes@melbourne.sgi.com, xfs@oss.sgi.com

Hi Christoph,

--On 17 March 2007 4:40:28 PM +0100 Christoph Hellwig <hch@lst.de> wrote:

> Looks like the code for dealing with x86/amd64 logs is never actually
> enable in mainline because nothing defines HAVE_FORMAT32.

It is enabled, the HAVE_FORMAT32 is #ifndef around some particular type
definitions. (The code has been tested:)

It is currently used because those header files are shared between
userspace and kernel. And in userspace, there is a case where the 32bit
format definition is already defined in another header file - that
case is for IRIX, whose pack syntax is different with its compiler.
So if this is a concern then I would need to have these defined elsewhere
or break the kernel/userspace link on this file, etc...
Suggestions welcome...

--Tim
