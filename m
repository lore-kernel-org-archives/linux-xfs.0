Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2EB327F5E
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 22:59:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08680304043
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 20:59:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 67gPqklZOgdLWuSo for <xfs@oss.sgi.com>;
	Wed, 11 Nov 2015 20:58:46 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 1BA5A612961A
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 22:58:46 -0600 (CST)
Subject: Re: [PATCH] xfs: create helper for bmap finish & trans join in
	xfs_attr.c
References: <56441B8E.6070603@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56441C85.2010406@sandeen.net>
Date: Wed, 11 Nov 2015 22:58:45 -0600
MIME-Version: 1.0
In-Reply-To: <56441B8E.6070603@redhat.com>
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
To: xfs@oss.sgi.com



On 11/11/15 10:54 PM, Eric Sandeen wrote:
> Calls to xfs_bmap_finish() and xfs_trans_ijoin(), and the
> associated comments were replicated several times across
> xfs_attr.c.
> 
> Factor out a new helper function, xfs_bmap_finish_and_join()
> to take care of this.
> 
> This also fixes an ASSERT() test of an uninitialized variable
> in several locations:
> 
> 	error = xfs_attr_thing(&args);
> 	if (!error) {
> 		error = xfs_bmap_finish(&args.trans, args.flist,
> 					&committed);
> 	}
> 	if (error) {
> 		ASSERT(committed);
> 
> If the first xfs_attr_thing() failed, we'd skip the xfs_bmap_finish,
> never set "committed", and then test it in the ASSERT.

Whoops, of course right after I send it I see that this can be used
(and the ASSERT problem exists) in xfs_attr_remote.c as well;
I'll send V2 tomorrow.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
