Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFA7B7F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 08:08:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EC54304051
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 06:08:16 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id pJ5xBwEKV5HCVQz9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 06:08:14 -0700 (PDT)
Date: Tue, 10 Mar 2015 13:08:05 +0000
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 4/4] mm: numa: Slow PTE scan rate if migration failures
	occur
Message-ID: <20150310130805.GB3406@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
	<1425741651-29152-5-git-send-email-mgorman@suse.de>
	<20150307163657.GA9702@gmail.com>
	<CA+55aFwDuzpL-k8LsV3touhNLh+TFSLKP8+-nPwMXkWXDYPhrg@mail.gmail.com>
	<20150308100223.GC15487@gmail.com> <20150308203145.GA4038@suse.de>
	<20150309210147.GA3406@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150309210147.GA3406@suse.de>
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
To: Ingo Molnar <mingo@kernel.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Mon, Mar 09, 2015 at 09:02:19PM +0000, Mel Gorman wrote:
> On Sun, Mar 08, 2015 at 08:40:25PM +0000, Mel Gorman wrote:
> > > Because if the answer is 'yes', then we can safely say: 'we regressed 
> > > performance because correctness [not dropping dirty bits] comes before 
> > > performance'.
> > > 
> > > If the answer is 'no', then we still have a mystery (and a regression) 
> > > to track down.
> > > 
> > > As a second hack (not to be applied), could we change:
> > > 
> > >  #define _PAGE_BIT_PROTNONE      _PAGE_BIT_GLOBAL
> > > 
> > > to:
> > > 
> > >  #define _PAGE_BIT_PROTNONE      (_PAGE_BIT_GLOBAL+1)
> > > 
> > 
> > In itself, that's not enough. The SWP_OFFSET_SHIFT would also need updating
> > as a partial revert of 21d9ee3eda7792c45880b2f11bff8e95c9a061fb but it
> > can be done.
> > 
> 
> More importantily, _PAGE_BIT_GLOBAL+1 == the special PTE bit so just
> updating the value should crash. For the purposes of testing the idea, I
> thought the straight-forward option was to break soft dirty page tracking
> and steal their bit for testing (patch below). Took most of the day to
> get access to the test machine so tests are not long running and only
> the autonuma one has completed;
> 

And the xfsrepair workload also does not show any benefit from using a
different bit either

                                       3.19.0             4.0.0-rc1             4.0.0-rc1             4.0.0-rc1
                                      vanilla               vanilla         slowscan-v2r7        protnone-v3r17
Min      real-fsmark        1164.44 (  0.00%)     1157.41 (  0.60%)     1150.38 (  1.21%)     1173.22 ( -0.75%)
Min      syst-fsmark        4016.12 (  0.00%)     3998.06 (  0.45%)     3988.42 (  0.69%)     4037.90 ( -0.54%)
Min      real-xfsrepair      442.64 (  0.00%)      497.64 (-12.43%)      456.87 ( -3.21%)      489.60 (-10.61%)
Min      syst-xfsrepair      194.97 (  0.00%)      500.61 (-156.76%)      263.41 (-35.10%)      544.56 (-179.30%)
Amean    real-fsmark        1166.28 (  0.00%)     1166.63 ( -0.03%)     1155.97 (  0.88%)     1183.19 ( -1.45%)
Amean    syst-fsmark        4025.87 (  0.00%)     4020.94 (  0.12%)     4004.19 (  0.54%)     4061.64 ( -0.89%)
Amean    real-xfsrepair      447.66 (  0.00%)      507.85 (-13.45%)      459.58 ( -2.66%)      498.71 (-11.40%)
Amean    syst-xfsrepair      202.93 (  0.00%)      519.88 (-156.19%)      281.63 (-38.78%)      569.21 (-180.50%)
Stddev   real-fsmark           1.44 (  0.00%)        6.55 (-354.10%)        3.97 (-175.65%)        9.20 (-537.90%)
Stddev   syst-fsmark           9.76 (  0.00%)       16.22 (-66.27%)       15.09 (-54.69%)       17.47 (-79.13%)
Stddev   real-xfsrepair        5.57 (  0.00%)       11.17 (-100.68%)        3.41 ( 38.66%)        6.77 (-21.63%)
Stddev   syst-xfsrepair        5.69 (  0.00%)       13.98 (-145.78%)       19.94 (-250.49%)       20.03 (-252.05%)
CoeffVar real-fsmark           0.12 (  0.00%)        0.56 (-353.96%)        0.34 (-178.11%)        0.78 (-528.79%)
CoeffVar syst-fsmark           0.24 (  0.00%)        0.40 (-66.48%)        0.38 (-55.53%)        0.43 (-77.55%)
CoeffVar real-xfsrepair        1.24 (  0.00%)        2.20 (-76.89%)        0.74 ( 40.25%)        1.36 ( -9.17%)
CoeffVar syst-xfsrepair        2.80 (  0.00%)        2.69 (  4.06%)        7.08 (-152.54%)        3.52 (-25.51%)
Max      real-fsmark        1167.96 (  0.00%)     1171.98 ( -0.34%)     1159.25 (  0.75%)     1195.41 ( -2.35%)
Max      syst-fsmark        4039.20 (  0.00%)     4033.84 (  0.13%)     4024.53 (  0.36%)     4079.45 ( -1.00%)
Max      real-xfsrepair      455.42 (  0.00%)      523.40 (-14.93%)      464.40 ( -1.97%)      505.82 (-11.07%)
Max      syst-xfsrepair      207.94 (  0.00%)      533.37 (-156.50%)      309.38 (-48.78%)      593.62 (-185.48%)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
