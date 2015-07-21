Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0EF3F7F6A
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 16:17:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC82B304051
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 14:17:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id my2SQ7h97tKaTW1B for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 14:17:14 -0700 (PDT)
Received: from Liberator.local (unknown [172.56.36.92])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B55E76184597
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 16:17:13 -0500 (CDT)
Message-ID: <55AEB6D6.7080007@sandeen.net>
Date: Tue, 21 Jul 2015 16:17:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: create new metadata UUID field and incompat flag
References: <55A7D414.2050606@sandeen.net> <55A7D47B.7030200@sandeen.net>
In-Reply-To: <55A7D47B.7030200@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

On 7/16/15 10:57 AM, Eric Sandeen wrote:
> This adds a new superblock field, sb_meta_uuid.  If set, along with
> a new incompat flag, the code will use that field on a V5 filesystem
> to compare to metadata UUIDs, which allows us to change the user-
> visible UUID at will.  Userspace handles the setting and clearing
> of the incompat flag as appropriate, as the UUID gets changed; i.e.
> setting the user-visible UUID back to the original UUID (as stored in
> the new field) will remove the incompatible feature flag.
> 
> If the incompat flag is not set, this copies the user-visible UUID into
> into the meta_uuid slot in memory when the superblock is read from disk;
> the meta_uuid field is not written back to disk in this case.
> 
> The remainder of this patch simply switches verifiers, initializers,
> etc to use the new sb_meta_uuid field.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This one was also

Reviewed-by: Brian Foster <bfoster@redhat.com>

but again has small changes to address Dave's points, and rebase
changes.

THanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
