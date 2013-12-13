Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A292C7F60
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 10:34:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92CC9304062
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:33:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id epEHpZGLyXIF2WBX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 08:33:30 -0800 (PST)
Date: Fri, 13 Dec 2013 08:31:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/4] xfs: allow linkat() on O_TMPFILE files
Message-ID: <20131213163118.GB20803@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
	<20131125214611.GI8803@dastard>
	<CAEH94Lixcey+PYGsLf3waeK1sv9QYriacMNe+pen-3jor3fG4g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEH94Lixcey+PYGsLf3waeK1sv9QYriacMNe+pen-3jor3fG4g@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Fri, Dec 13, 2013 at 07:34:43PM +0800, Zhi Yong Wu wrote:
> > Uggh. For the small amount of extra space needed for the unlinked
> > list reservation, I would simply add it to the tr_link reservation
> > and be done with it. That gets rid of the need for the noise here.
> >
> >
> > As per above, fold this into xfs_calc_link_reservation() by adding a:
> >
> >
> >                 + xfs_calc_iunlink_remove_resv(mp);
> This way seems to not work...
> In xfs_calc_link_reservation(), How to determine if it is for one
> regular file or O_TMPFILE file? since this functions is only passed in
> mp?

The way I understand Dave above is that you should always reserve
the higher amount.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
