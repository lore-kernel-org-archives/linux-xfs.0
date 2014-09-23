Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0197B29DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:45:14 -0500 (CDT)
Date: Tue, 23 Sep 2014 15:45:13 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140923204512.GI4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
	<20140922184145.GH4482@sgi.com>
	<20140922192958.GJ4120@two.firstfloor.org>
	<54219C17.3090104@sgi.com>
	<20140923201540.GB15923@two.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140923201540.GB15923@two.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, Olaf Weber <olaf@sgi.com>, xfs@oss.sgi.com

Hi Andi,

On Tue, Sep 23, 2014 at 10:15:40PM +0200, Andi Kleen wrote:
> > You only pay the space cost if you use it, similar to the nls tables.
> 
> The way Linux module loading works these things are loaded by default,
> not when someone needs it.
> 
> So no, you (or rather every unfortunate Linux XFS user) would pay it always,
> unless you black list the module or rebuild the kernel.

The suggestion to use symbol_get was made in response to the initial
post of the series.  In my testing the normalization module did not load
until I attempted to mount a filesystem which required it.  Seems to
work ok.

See patch 10, "xfs: implement demand load of utf8norm.ko". 

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
