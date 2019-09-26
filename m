Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F19C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA18321D56
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfIZOkt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfIZOkt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 10:40:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 62BF910576CE;
        Thu, 26 Sep 2019 14:40:48 +0000 (UTC)
Received: from dresden.str.redhat.com (unknown [10.40.205.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6605E5D6A7;
        Thu, 26 Sep 2019 14:40:47 +0000 (UTC)
Subject: Re: [PATCH] xfs: Fix tail rounding in xfs_alloc_file_space()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
References: <20190926142238.26973-1-mreitz@redhat.com>
 <20190926143704.GA9916@magnolia>
From:   Max Reitz <mreitz@redhat.com>
Autocrypt: addr=mreitz@redhat.com; prefer-encrypt=mutual; keydata=
 mQENBFXOJlcBCADEyyhOTsoa/2ujoTRAJj4MKA21dkxxELVj3cuILpLTmtachWj7QW+TVG8U
 /PsMCFbpwsQR7oEy8eHHZwuGQsNpEtNC2G/L8Yka0BIBzv7dEgrPzIu+W3anZXQW4702+uES
 U29G8TP/NGfXRRHGlbBIH9KNUnOSUD2vRtpOLXkWsV5CN6vQFYgQfFvmp5ZpPeUe6xNplu8V
 mcTw8OSEDW/ZnxJc8TekCKZSpdzYoxfzjm7xGmZqB18VFwgJZlIibt1HE0EB4w5GsD7x5ekh
 awIe3RwoZgZDLQMdOitJ1tUc8aqaxvgA4tz6J6st8D8pS//m1gAoYJWGwwIVj1DjTYLtABEB
 AAG0HU1heCBSZWl0eiA8bXJlaXR6QHJlZGhhdC5jb20+iQFTBBMBCAA9AhsDBQkSzAMABQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheABQJVzie5FRhoa3A6Ly9rZXlzLmdudXBnLm5ldAAKCRD0
 B9sAYdXPQDcIB/9uNkbYEex1rHKz3mr12uxYMwLOOFY9fstP5aoVJQ1nWQVB6m2cfKGdcRe1
 2/nFaHSNAzT0NnKz2MjhZVmcrpyd2Gp2QyISCfb1FbT82GMtXFj1wiHmPb3CixYmWGQUUh+I
 AvUqsevLA+WihgBUyaJq/vuDVM1/K9Un+w+Tz5vpeMidlIsTYhcsMhn0L9wlCjoucljvbDy/
 8C9L2DUdgi3XTa0ORKeflUhdL4gucWoAMrKX2nmPjBMKLgU7WLBc8AtV+84b9OWFML6NEyo4
 4cP7cM/07VlJK53pqNg5cHtnWwjHcbpGkQvx6RUx6F1My3y52vM24rNUA3+ligVEgPYBuQEN
 BFXOJlcBCADAmcVUNTWT6yLWQHvxZ0o47KCP8OcLqD+67T0RCe6d0LP8GsWtrJdeDIQk+T+F
 xO7DolQPS6iQ6Ak2/lJaPX8L0BkEAiMuLCKFU6Bn3lFOkrQeKp3u05wCSV1iKnhg0UPji9V2
 W5eNfy8F4ZQHpeGUGy+liGXlxqkeRVhLyevUqfU0WgNqAJpfhHSGpBgihUupmyUg7lfUPeRM
 DzAN1pIqoFuxnN+BRHdAecpsLcbR8sQddXmDg9BpSKozO/JyBmaS1RlquI8HERQoe6EynJhd
 64aICHDfj61rp+/0jTIcevxIIAzW70IadoS/y3DVIkuhncgDBvGbF3aBtjrJVP+5ABEBAAGJ
 ASUEGAEIAA8FAlXOJlcCGwwFCRLMAwAACgkQ9AfbAGHVz0CbFwf9F/PXxQR9i4N0iipISYjU
 sxVdjJOM2TMut+ZZcQ6NSMvhZ0ogQxJ+iEQ5OjnIputKvPVd5U7WRh+4lF1lB/NQGrGZQ1ic
 alkj6ocscQyFwfib+xIe9w8TG1CVGkII7+TbS5pXHRxZH1niaRpoi/hYtgzkuOPp35jJyqT/
 /ELbqQTDAWcqtJhzxKLE/ugcOMK520dJDeb6x2xVES+S5LXby0D4juZlvUj+1fwZu+7Io5+B
 bkhSVPb/QdOVTpnz7zWNyNw+OONo1aBUKkhq2UIByYXgORPFnbfMY7QWHcjpBVw9MgC4tGeF
 R4bv+1nAMMxKmb5VvQCExr0eFhJUAHAhVg==
Message-ID: <40d1b2d8-5f17-a76d-7124-4b85ac035e80@redhat.com>
Date:   Thu, 26 Sep 2019 16:40:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190926143704.GA9916@magnolia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hZFGmoplRS5wjP10UqtWGZWealNdhNf5r"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 26 Sep 2019 14:40:48 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hZFGmoplRS5wjP10UqtWGZWealNdhNf5r
Content-Type: multipart/mixed; boundary="EyRGEvf5hwkTZrgWHDWmvBFpRY7ow34Ip"

--EyRGEvf5hwkTZrgWHDWmvBFpRY7ow34Ip
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26.09.19 16:37, Darrick J. Wong wrote:
> On Thu, Sep 26, 2019 at 04:22:38PM +0200, Max Reitz wrote:
>> To ensure that all blocks touched by the range [offset, offset + count=
)
>> are allocated, we need to calculate the block count from the differenc=
e
>> of the range end (rounded up) and the range start (rounded down).
>>
>> Before this patch, we just round up the byte count, which may lead to
>> unaligned ranges not being fully allocated:
>>
>> $ touch test_file
>> $ block_size=3D$(stat -fc '%S' test_file)
>> $ fallocate -o $((block_size / 2)) -l $block_size test_file
>> $ xfs_bmap test_file
>> test_file:
>>         0: [0..7]: 1396264..1396271
>>         1: [8..15]: hole
>>
>> There should not be a hole there.  Instead, the first two blocks shoul=
d
>> be fully allocated.
>>
>> With this patch applied, the result is something like this:
>>
>> $ touch test_file
>> $ block_size=3D$(stat -fc '%S' test_file)
>> $ fallocate -o $((block_size / 2)) -l $block_size test_file
>> $ xfs_bmap test_file
>> test_file:
>>         0: [0..15]: 11024..11039
>=20
> Code looks ok; by any chance do you have an xfstest we could add to the=

> regresion test suite?
I=E2=80=99ll look into it.

Max


--EyRGEvf5hwkTZrgWHDWmvBFpRY7ow34Ip--

--hZFGmoplRS5wjP10UqtWGZWealNdhNf5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl2Mze0ACgkQ9AfbAGHV
z0CxgQf9HIs3Evz4CfhNcmKJ5n9fy+XjJro/bbb7uKEFtLjbNegHCUaEz0YMtZsL
l28cltHVlay6BCvQbUpy9w4uTcmySl6PDn4SpI1/YUZjFH5gPVYi0KWMr2EBRIJo
4wZPoIW4vWL4YIzobrj33wKTbb6zzkTA9zVU+af5kfFbTlnTY/4k5G6sCNkkZTDh
3H+tW36G6uog4zGlytlxZoh73b+EevLLXnuPMUnsYOYCFAZjHPBEawtQ8iwPljBo
UMi+fUK7xGZaCZ7YMz9D5kyjLBVcFFshpHUnNATZUBS9GpaSg5a9ZXtQFg0ou3FK
8fez/FUusxsrXlKv37R6zdDW8YgEPg==
=E20p
-----END PGP SIGNATURE-----

--hZFGmoplRS5wjP10UqtWGZWealNdhNf5r--
