Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E8C9B7F60
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 16:34:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D67098F8037
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 14:34:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nvUjeNl8Sc9atetV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 14:34:13 -0800 (PST)
Date: Mon, 3 Nov 2014 17:34:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 05/17] xfs: create macros/helpers for dealing with
	sparse inode chunks
Message-ID: <20141103223407.GA14732@bfoster.bfoster>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
	<1415031146-9107-6-git-send-email-bfoster@redhat.com>
	<CA+o=1OWm3XWUgNXR1_CravnEBL8fD8dwyMvY4CN9rbAsw0Q4Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OWm3XWUgNXR1_CravnEBL8fD8dwyMvY4CN9rbAsw0Q4Sw@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 03, 2014 at 11:12:12PM +0100, Fanael Linithien wrote:
> 2014-11-03 17:12 GMT+01:00 Brian Foster <bfoster@redhat.com>:
> >
> > +static inline bool xfs_inobt_issparse(uint16_t holemask)
> > +{
> > +       return holemask == 0 ? false : true;
> > +}
> 
> Surely that should be "return holemask != 0;"?
> 

ir_holemask bits are set for holes in the inode chunk and unset for
allocated regions. This means that ir_holemask == 0 for a normal,
fully-allocated chunk and != 0 otherwise (some bits are set to indicate
the chunk has a hole). Check out the commit log for patch 4 for
reasoning.

Brian

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
