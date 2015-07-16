Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C51D7F85
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 02:13:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 34C258F8035
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2015 00:13:05 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id G8ONF1xkY4djsgDq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jul 2015 00:13:00 -0700 (PDT)
Date: Thu, 16 Jul 2015 03:12:57 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1131231186.27908155.1437030777674.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150715235306.GT3902@dastard>
References: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
	<1436964412-12093-2-git-send-email-jtulak@redhat.com>
	<20150715235306.GT3902@dastard>
Subject: Re: [PATCH 1/2] Prefix LIST_... macros to XFS_LIST_...
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: xfs@oss.sgi.com
> Sent: Thursday, July 16, 2015 1:53:06 AM
> Subject: Re: [PATCH 1/2] Prefix LIST_... macros to XFS_LIST_...
> 
> On Wed, Jul 15, 2015 at 02:46:51PM +0200, Jan Tulak wrote:
> > OS X has some conflicting LIST_ macros, so prefix the XFS ones.
> 
> What are the macros that conflict and where do they come from?
>

Ah, I see, I messed this patch a bit. :P 

Written as regular expressions, only ^LIST_[A-Z_]+$ macros are an 
issue. Like LIST_HEAD and so on. The IRIX and ioctls should be OK. 
I'm fixing it. :-)

Thanks for noticing it,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
