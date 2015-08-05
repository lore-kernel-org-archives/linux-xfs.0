Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C8477FC6
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:50:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16CDAAC00C
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 02:50:08 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id x7waXV0QWW9kh4Vg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 02:50:06 -0700 (PDT)
Date: Wed, 5 Aug 2015 05:49:37 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <955551007.3098690.1438768177102.JavaMail.zimbra@redhat.com>
In-Reply-To: <20150804230000.GW16638@dastard>
References: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
	<1438680314-23950-1-git-send-email-jtulak@redhat.com>
	<20150804111812.GD18906@infradead.org>
	<773923690.2696215.1438697980321.JavaMail.zimbra@redhat.com>
	<20150804230000.GW16638@dastard>
Subject: Re: [PATCH v4 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "Jan Tulak" <jtulak@redhat.com>
> Cc: "Christoph Hellwig" <hch@infradead.org>, xfs@oss.sgi.com
> Sent: Wednesday, August 5, 2015 1:00:00 AM
> Subject: Re: [PATCH v4 04/11] xfsprogs: Add ifdef dirent checks where it was	missing
> 
> On Tue, Aug 04, 2015 at 10:19:40AM -0400, Jan Tulak wrote:
> > ----- Original Message -----
> > > From: "Christoph Hellwig" <hch@infradead.org>
> > > 
> > > Needs to be fixed to avoid > 80 char lines.
> > > 
> > 
> > I don't see any >80 char line in this patch. O_o
> > The longest line is 73 in the code and 62 in commit
> > message. Though... maybe it can be a tab width issue?
> > I use four spaces for a tab...
> 
> 8 spaces to a tab, please. Same coding style rules as for writing
> kernel code. ;)

All right, fixed patch sent. :-)

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
