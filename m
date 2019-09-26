Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DB0C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC737222C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 13:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfIZNQv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 09:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfIZNQv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 09:16:51 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88B2018C892C;
        Thu, 26 Sep 2019 13:16:50 +0000 (UTC)
Received: from dresden.str.redhat.com (unknown [10.40.205.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 883C65C21A;
        Thu, 26 Sep 2019 13:16:49 +0000 (UTC)
Subject: Re: xfs_alloc_file_space() rounds len independently of offset
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <6d62fb2a-a4e6-3094-c1bf-0ca5569b244c@redhat.com>
 <20190926125928.GC26832@bfoster>
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
Message-ID: <3e2c1587-4f8d-0425-bb76-70d4325bdf90@redhat.com>
Date:   Thu, 26 Sep 2019 15:16:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190926125928.GC26832@bfoster>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xzJNA1VJ9XkKrZ0TM65ENrh47GwxSrtOF"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Thu, 26 Sep 2019 13:16:50 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xzJNA1VJ9XkKrZ0TM65ENrh47GwxSrtOF
Content-Type: multipart/mixed; boundary="hWst4XDtDPZQIaP9GZGc2cNgxwTflTRjj"

--hWst4XDtDPZQIaP9GZGc2cNgxwTflTRjj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26.09.19 14:59, Brian Foster wrote:
> On Thu, Sep 26, 2019 at 12:57:49PM +0200, Max Reitz wrote:
>> Hi,
>>
>> I=E2=80=99ve noticed that fallocating some range on XFS sometimes does=
 not
>> include the last block covered by the range, when the start offset is
>> unaligned.
>>
>> (Tested on 5.3.0-gf41def397.)
>>
>> This happens whenever ceil((offset + len) / block_size) - floor(offset=
 /
>> block_size) > ceil(len / block_size), for example:
>>
>> Let block_size be 4096.  Then (on XFS):
>>
>> $ fallocate -o 2048 -l 4096 foo   # Range [2048, 6144)
>> $ xfs_bmap foo
>> foo:
>>         0: [0..7]: 80..87
>>         1: [8..15]: hole
>>
>> There should not be a hole there.  Both of the first two blocks should=

>> be allocated.  XFS will do that if I just let the range start one byte=

>> sooner and increase the length by one byte:
>>
>> $ rm -f foo
>> $ fallocate -o 2047 -l 4097 foo   # Range [2047, 6144)
>> $ xfs_bmap foo
>> foo:
>>         0: [0..15]: 88..103
>>
>>
>> (See [1] for a more extensive reasoning why this is a bug.)
>>
>>
>> The problem is (as far as I can see) that xfs_alloc_file_space() round=
s
>> count (which equals len) independently of the offset.  So in the
>> examples above, 4096 is rounded to one block and 4097 is rounded to tw=
o;
>> even though the first example actually touches two blocks because of t=
he
>> misaligned offset.
>>
>> Therefore, this should fix the problem (and does fix it for me):
>>
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index 0910cb75b..4f4437030 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -864,6 +864,7 @@ xfs_alloc_file_space(
>>  	xfs_filblks_t		allocatesize_fsb;
>>  	xfs_extlen_t		extsz, temp;
>>  	xfs_fileoff_t		startoffset_fsb;
>> +	xfs_fileoff_t		endoffset_fsb;
>>  	int			nimaps;
>>  	int			quota_flag;
>>  	int			rt;
>> @@ -891,7 +892,8 @@ xfs_alloc_file_space(
>>  	imapp =3D &imaps[0];
>>  	nimaps =3D 1;
>>  	startoffset_fsb	=3D XFS_B_TO_FSBT(mp, offset);
>> -	allocatesize_fsb =3D XFS_B_TO_FSB(mp, count);
>> +	endoffset_fsb =3D XFS_B_TO_FSB(mp, offset + count);
>> +	allocatesize_fsb =3D endoffset_fsb - startoffset_fsb;
>>
>>  	/*
>>  	 * Allocate file space until done or until there is an error
>>
>=20
> That looks like a reasonable fix to me and it's in the spirit of how
> xfs_free_file_space() works as well (outside of the obvious difference
> in how unaligned boundary blocks are handled). Care to send a proper
> patch?

I=E2=80=99ve never sent a kernel patch before, but I=E2=80=99ll give it a=
 go.

Max


--hWst4XDtDPZQIaP9GZGc2cNgxwTflTRjj--

--xzJNA1VJ9XkKrZ0TM65ENrh47GwxSrtOF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEkb62CjDbPohX0Rgp9AfbAGHVz0AFAl2MukAACgkQ9AfbAGHV
z0BtdQf9HP2FGNK9jD82y7wTxr5Qm50Aa8cx/4o9H+I/yDcPxUHUtms/jciAf1jR
yaYoGMjVtXlRuH1a9H6Ouext1i47QSSWDCjGjJDYv4KEjkIOfSVAXzS8g2eokho2
PPy/nSrFdLKl4f4DPoH0N3vfHKNY/+Zvgs/YGlNbbAvAvyasmwCW0gZphz7tnbah
uth4/WuD10MstkBFAAGbEhmSNbnGx0vAEKFgBwcnXFm95O02JjfKfiwV8CandxIg
B/Hey3zZYai4Wmc2m13j1O7Gflu2ts69n2FZ99JE2Qw1bmxsakwLEgyi8rjBqqxZ
lDd9deOoHyEYf/LAFpHnvTrxuoZk5g==
=7tnS
-----END PGP SIGNATURE-----

--xzJNA1VJ9XkKrZ0TM65ENrh47GwxSrtOF--
