Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E5B17F57
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 08:53:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C7B330406B
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 06:53:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id eaDBXtd1irko3Shb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 06:53:06 -0700 (PDT)
Date: Fri, 1 Aug 2014 06:53:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Is jdm_delete_filehandle part of a public API?
Message-ID: <20140801135305.GA31894@infradead.org>
References: <53D7DA7F.2040706@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53D7DA7F.2040706@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 29, 2014 at 12:31:43PM -0500, Eric Sandeen wrote:
> I was cleaning up xfsprogs to plug some leaks, and wanted to use
> jdm_delete_filehandle().  I noticed that it has an "hlen" argument which
> is unused.
> 
> Can we remove that, or is this part of a public API?  It's not in any
> manpage (or even called anywhere in xfsprogs/xfstests/xfsdump/dmapi)
> but it is in a public header...
> 
> anyone know?
> 
> If needed I guess I can just call it with hlen==0, but that seems odd.

If it's in a public header we shouldn't touch it unless there's a
pressing need.


Talking about libhandle: this one has been a bit bitrotted.  Maybe it's
a good time to move everything over to the kernel by handle syscalls
and deprecated it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
