Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B8EE7F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 18:57:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 755F98F8035
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 16:57:34 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	iw4IwTahVczrFyt3 for <xfs@oss.sgi.com>;
	Tue, 07 Jan 2014 16:57:30 -0800 (PST)
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
	INIT_WORK_ONSTACK()
Date: Wed, 8 Jan 2014 00:57:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01BED1C3@SHSMSX101.ccr.corp.intel.com>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
	<1389084814.3650.70.camel@cliu38-desktop-build>
	<52CBE321.4050906@oracle.com>
In-Reply-To: <52CBE321.4050906@oracle.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Jeff Liu <jeff.liu@oracle.com>, "dchinner@redhat.com" <dchinner@redhat.com>, "bpm@sgi.com" <bpm@sgi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello Jeff,

> -----Original Message-----
> From: Jeff Liu [mailto:jeff.liu@oracle.com]
> Sent: Tuesday, January 07, 2014 7:21 PM
> To: Liu, Chuansheng; dchinner@fromorbit.com; bpm@sgi.com
> Cc: linux-kernel@vger.kernel.org; xfs@oss.sgi.com
> Subject: Re: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
> INIT_WORK_ONSTACK()
> 
> Hi Chuansheng,
> 
> On 01/07 2014 16:53 PM, Chuansheng Liu wrote:
> >
> > In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> > call destroy_work_on_stack() which frees the debug object to pair
> > with INIT_WORK_ONSTACK().
> >
> > Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> > ---
> Thanks for your patch and it work fine for my testing.  I missed this in an
> old commit: [ 3b876c8f2a xfs: fix debug_object WARN at xfs_alloc_vextent() ]
Thanks your testing.

> 
> Just out of curious, do you notice memory leaks or other hints which help you
> finding out this problem?
I am trying to use the INIT_WORK_ONSTACK() in my code, then I found in some places
Calling destroy_work_on_stack() is missed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
