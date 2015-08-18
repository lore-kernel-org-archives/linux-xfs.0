Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 744877F47
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 00:31:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 104A6AC005
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 22:31:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v8PMwd5X2ypU2Ok8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 22:31:12 -0700 (PDT)
Date: Tue, 18 Aug 2015 13:31:09 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: generic/04[89] fail on XFS due to change in writeback code
	[4.2-rc1 regression]
Message-ID: <20150818053109.GB17933@dhcp-13-216.nay.redhat.com>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813232400.GH4496@mtj.duckdns.org>
	<20150814061939.GK17933@dhcp-13-216.nay.redhat.com>
	<20150817202709.GJ21075@mtj.duckdns.org>
	<20150818035722.GA17933@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818035722.GA17933@dhcp-13-216.nay.redhat.com>
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

On Tue, Aug 18, 2015 at 11:57:22AM +0800, Eryu Guan wrote:
> On Mon, Aug 17, 2015 at 04:27:09PM -0400, Tejun Heo wrote:
> > Hello, Eryu.
> > 
> > lol that wasn't supposed to fix the problem you were seeing.  Can you
> > please apply the following patch and see whether any warning triggers?
> 
> Sure, will do.

Still no warning triggered, and test passed too with this patch.

Test patch applied on top of 4.2-rc6, ran generic/048 generic/049 20
times in loop.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
