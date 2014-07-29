Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 54C427F37
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 13:18:25 -0500 (CDT)
Message-ID: <53D7E56C.8020103@sgi.com>
Date: Tue, 29 Jul 2014 13:18:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Is jdm_delete_filehandle part of a public API?
References: <53D7DA7F.2040706@redhat.com>
In-Reply-To: <53D7DA7F.2040706@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 07/29/14 12:31, Eric Sandeen wrote:
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
>
> Thanks,
> -Eric

The first thing that comes to mind is maybe they trying to distinguish 
between a fshandle or handle. Or they we trying to be consistent with 
the allocation calls.

The libhandle free_handle has the same calling parameters. It also does 
nothing with the length. That we cannot change without breaking existing 
code.

I will look/ask around.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
