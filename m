Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D8427F37
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 04:29:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC888AC001
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 02:29:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xzJ2oneT7BHJilMe (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 02:29:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 3FC6591341
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 09:29:50 +0000 (UTC)
Date: Fri, 23 Oct 2015 11:29:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_io: implement 'inode' command V3
Message-ID: <20151023092946.GA752@redhat.com>
References: <1445257880-30797-1-git-send-email-cmaiolino@redhat.com>
	<20151022144255.GB13661@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151022144255.GB13661@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Thanks for the review Brian, I'll walk over it and fix the points you mentioned.
> 
> 
> I still don't really get why we have separate -l and -s options here. It
> seems to me that the behavior of -l already gives us the information
> that -s does. Even if that's not obvious enough, the -l command could
> just print out both. For example:
> 
>       "Largest inode: 1234 (32-bit)"

I agree with you here, but, I'll let Dave answer this question, maybe he had 
some another idea for it that I'm not aware of. 

Cheers.
-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
