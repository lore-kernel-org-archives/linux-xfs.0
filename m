Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2DFB77F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 14:56:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0B761304066
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:56:55 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id MhcluP1hdyn6uBrK
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:56:53 -0700 (PDT)
Message-ID: <531E187D.4000406@fb.com>
Date: Mon, 10 Mar 2014 15:54:37 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: add test for btrfs-progs restore feature
References: <1393352816-26065-1-git-send-email-fdmanana@gmail.com>
	<1393375444-3760-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1393375444-3760-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/25/2014 07:44 PM, Filipe David Borba Manana wrote:
> This is a regression test to verify that the restore feature of
> btrfs-progs is able to correctly recover files that have compressed
> extents, specially when the respective file extent items have a
> non-zero data offset field.
> 
> This issue is fixed by the following btrfs-progs patch:
> 
> Btrfs-progs: fix restore dealing with compressed extents
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com> ---
> 
> V2: Fixed title of btrfs-progs patch in the comment and commit
> message. V3: Make use of TEST_DIR instead of /tmp, defined
> $here=`pwd` and better comments about the conditions necessary to
> make the test fail. As suggested by Dave Chinner.
> 

Tested with and without the patch, works as expected.  I would go even
further and say create a $seqnum directory in $TEST_DIR to restore
into but I'm not that married to the idea

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHhh9AAoJEANb+wAKly3B6LYP/1DWxfxymW3dyx56qOYH7R/d
z9GsJPapK5bcwF27hYOVbKooLIGYbB/XrJox8QK/+KCrg6mcJRGDwvYClB7nX83R
wD3izB+hgOEcOs/ucVDT8dQECSimfyiZBoG3oXptdX53XeXwOLkzXX10rRJpawys
C5Ztf0RRKUiGBcdJX9mYFXjx9MC37rTjMHAzaobb5CMYQKHpncn4BqWwONGhjPAg
ZvdXTX5V+qT/VTRFzXrcw7ZdIAIajxAPnfM6zCG9GG+0D5w9MPjzS1OvDA95SdhZ
XL9cmASOGDKRodNbtlFZlKGqvvVw4L6fRw8Qj0GJTxLBU1ZnktZwQJKjAarKoSvk
cIIl3BtCQFifGkKLjpRfEPxrifRe3vMP2nxwqF9wiYv2Q3kl/oE8RX0l+dAQgZ6h
Ls+BkxdUVUQLtK2JR2YbQqsSe/UvwqgnPF9nPTv9v1iAhkZV4pJcbGvRZcx330Dh
uQlqZOHkEhF/NhksocQJPExwIMndhT2cUxvtfBCO5kNiiZF0XRWyYDOW6VXp6ajQ
ELYvcmBMkJMAt5Il7a2pichQXRIjXybNXAgbdMJq+2jBL/WQDg5IuH+NRMG/TBUZ
gJv708ciCyjoDsgobA+MUNfVgtPN0iBPV5tDtysP1K9taEIPlFEoyvRYRCr04XYq
TiIG5wmFhxieOv57wcX6
=kszA
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
