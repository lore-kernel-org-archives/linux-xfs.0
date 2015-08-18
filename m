Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF8F429DF5
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 22:57:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DFE2D30405F
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 20:57:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2dLtBAiMs2W7ry74 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 20:57:26 -0700 (PDT)
Date: Tue, 18 Aug 2015 11:57:22 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: generic/04[89] fail on XFS due to change in writeback code
	[4.2-rc1 regression]
Message-ID: <20150818035722.GA17933@dhcp-13-216.nay.redhat.com>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813232400.GH4496@mtj.duckdns.org>
	<20150814061939.GK17933@dhcp-13-216.nay.redhat.com>
	<20150817202709.GJ21075@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150817202709.GJ21075@mtj.duckdns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: axboe@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 04:27:09PM -0400, Tejun Heo wrote:
> Hello, Eryu.
> 
> lol that wasn't supposed to fix the problem you were seeing.  Can you
> please apply the following patch and see whether any warning triggers?

Sure, will do.

> Also, you aren't using lazytime, right?

Correct, I'm not using lazytime.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
