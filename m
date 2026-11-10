Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794324384;
	b=4Z5PxCnloAXnNkDZnDk0nWrUNmvgrmsBukZQV75ycSjCLfYox68aCAd/8tb2J4hYdmSL
	 NeRNzqYlXw++OiP+VeRkGw9wzshs+bgqhWTA7c0FEW+XJnIntJ8gtJ7EOgb0uyEQsRJm8
	 shrcsQL1PIwmxmTk3po3NAZza6KEdd27AyR1VISaANfG0AEoHuCcyddr/bczEXvB/CdoQ
	 wKX9vT89P8dWekwgUM3hsuJiUiE+MdUzxoPkZ9n/3RoLN6ECKSxZU6pY4iYEVkRP91ZbR
	 +bMgRVLXyRGeBIzrdvNTuJYdFY3XA0rM0uhxqSwbrubw+Nn/r/FNSTCIH35M2qTuUlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324384;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=5X6BnxPfK1ssLILeumEe6OErFUlo2jB/lASKyCrOw48=;
	b=iVs8lqmFzCyRAji1WCplq/N0Loqf9MU+Yq7B69Y+gqI8Ftma5xQrrQ1dHzryATdnBR25
	 SiZegKrGbfvNJTWMhKXCicMYS6p/ZI580bDWtOItSgbGpcUJFUP6d2ofz3xKMuSNE+5U5
	 vPNF9Rb8K6tEeSMK1nTXf11ujg7BzX25OCicQ/c5WFh391gP6wNVZfvCQbmnf4vg1TQXa
	 U0T8DwPVFLVd0UyuT8rrP6Mh5BgfOHwfOCv3jBK1Rgd8XQ/2bskVH3zAAM4IQEho/BNzE
	 nDZpoLq909f+z56U/c2+mCOSo8cD/zmC5kj4Mb6zd59g5tMJXafN8saw6cod48FFN/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PxN3hRjK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6715C606A323
	for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PxN3hRjK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AC01F008A1;
	Tue, 10 Nov 2026 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794324384;
	bh=5X6BnxPfK1ssLILeumEe6OErFUlo2jB/lASKyCrOw48=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=PxN3hRjK0+lbVcebpFZc31cA/tUmoTQ/KdjDTDo9an2pnmCcwWgWOkSAXY44u00jB
	 lA3PY878I9zwmrMQ24XlIhRa5uwvYRbLxC44+/JiIQNBn6i2pFp98M/nWniaRMPUk0
	 IuBhL3OoEg4Ubn1U/akfsRmSrTFRCJ6+KoZ8yQfr0zeyaaoI9wAHc5pLeCQ+Im4wzQ
	 yN2vjyQt5WINwJ/e+G1sKk8gZk4SvkhdP4k7VQ3lXXWyetr79KHRhrIlolfmoiOc1G
	 uSAElK/6zqVebT0MKLFGdWIU+BxEG1VwdgEzA0X+l0HgHPv9G14etc9lqRgdlBn2oD
	 E1Wkrw78va6FQ==
Received: from stl-compute-04.internal (stl-compute-04.internal [10.204.2.64])
	by mailfauth.stl.internal (Postfix) with ESMTP id 4D2C5780043;
	Tue, 10 Nov 2026 10:26:23 -0500 (EST)
Received: from stl-imap-13 ([10.204.2.104])
  by stl-compute-04.internal (MEProxy); Tue, 10 Nov 2026 10:26:23 -0500
X-ME-Sender: <xms:nzfzarQuXI2ycRFXueWnTo-LDeFz4L2rj2zbhpm5BQJAbIOsJ7PTjQ>
    <xme:nzfzanlutAPQady2fL1aifVw8RNO-hlL_suWKpQIgv2z-lSSouU_f5xO-_4l_ve6E
    YgdEdSW-r9PS9o9ofE11n7vPbx5C1uZqwsLjZgatTbUTntjLNMKMHH4>
X-ME-Proxy-Cause: dmFkZTF8m6Ghz3gZoGm1dS9Vm1TBYtGNlIdVpX7I0Zh8N8kCnHDcmsPQjzaM/FW3Vq2KhS
    /v2Fk+WpJUyhanpCyyf8XISeXKb8immVK/FeUEM+fDMD6UrRM5XuI5/n69NouFbOT/YEIl
    rhgHI+BTVsh9uisi/H4HtPNT7UCeQbzE8zLCQu54wpB4WK5ykMjzgyF18T0bXxRzARHB1y
    7kAKGQQ/u+Hdvt3qLitsELTpQm6LM5epKMjn2aTclHf4TlH7eiUYELUYX8ahOUZh8ojaY0
    3E/bIUlRv/jE2kwl9I57OwdgVnJrHRTLLdfTy1Nb+zbMdsL468FgR35EVhrxiNV6y9injc
    5EbQ3bXHuesiy+GVotifDqoOJGynevAFmhY04AMowQT2u3beT8WeVA9uKY+zfUwjim1z2Y
    EttHiZ/ZxJ3qcQB660QVhPp4cmvSPfBB8EB2eCPZdzCCbYDw/RaRI3Vz+MqlYXP7DqhIpz
    xuP8jBLynR8CRc+Is0O7jOrgLTR5+3FVfNu/PNcFtMeCEvQgicbb1GrjnIML6zw6qkfscA
    x3lplgEeJlvvIsnFaz1Z60d9jvSnTaghKgD8WllZKtybMUqgQNua9pzjk+PuEEvghNQH2O
    GJ6LK3I97Shpg+MRubXs9ieb0CGKOCM1RX8S9BLuhEbHJwZSqe6YD3QhbQFA
X-ME-Proxy: <xmx:nzfzai9bk8pcl6boPlxMuOkRGDtXFU0KB3J1qnj2u23MUHNu-sxtBQ>
    <xmx:nzfzaouEAE8t8N7DvdvCiGX3mhD4ZmOLlX5mvzQxU89ukJapR7yyqA>
    <xmx:nzfzai26MWjkm4bdifh44P55Ol7zA2V-rhkAm7yWmoBOe3CmNjnYHA>
    <xmx:nzfzatTDXnSUHHbEoHP5jx6GOerMPQoEMQYUAV7z52a4uUtIUFtUEg>
    <xmx:nzfzamebNJn5Vhhhq8IC5w1GPBKgxNQyvQ2Kad5io0CzWqUG_NEsCvw2>
Feedback-ID: iccae4b50:Fastmail
Received: by mailuser.stl.internal (Postfix, from userid 501)
	id E6EF7F60082; Tue, 10 Nov 2026 10:26:22 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A0RLlzEJ3gWV
Date: Tue, 10 Nov 2026 10:26:02 -0500
From: "Chris Mason" <mason@kernel.org>
To: "Carlos Maiolino" <cem@kernel.org>, "Tal Zussman" <tz2294@columbia.edu>
Cc: "Theodore Tso" <tytso@mit.edu>, "Dave Chinner" <david@fromorbit.com>,
 "Jan Kara" <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 "Josef Bacik" <josef@toxicpanda.com>, "Christoph Hellwig" <hch@lst.de>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <5a3ef1c0-2a03-4d53-89fa-71319d2f938d@app.fastmail.com>
In-Reply-To: <avLhEEZjDdQha7ul@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <20261109235111.14129-6-mason@kernel.org>
 <avLhEEZjDdQha7ul@nidhogg.toxiclabs.cc>
Subject: Re: [PATCH v6 05/10] fs: validate atomic writes after O_APPEND and limits
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Nov 10, 2026, at 4:41 AM, Carlos Maiolino wrote:
> On Mon, Nov 09, 2026 at 06:51:16PM -0500, Chris Mason wrote:
>> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
>> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
>> aligned.
>> 
>> XFS and ext4 call generic_atomic_write_valid() on the range that the
>> caller passed. But generic_write_checks() changes the range later:
>> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
>> then fill only a part of a new block, and still map the whole block into
>> the file:
>> 
>>     block size 4096, i_size 512, O_APPEND
>>     validated:        0 to 4095
>>     written:          512 to 4607
>>     new blocks:       0 to 8191
>>     stale below EOF:  0 to 511
>> 
>> The fix used here is to validate an atomic write in
>> generic_write_checks(), after its range is final, and to refuse one that
>> was cut. XFS no longer picks the path of an atomic write by the
>> alignment of the range that the caller passed.
>> 
>> Fixes: f096207d3276 ("xfs: Validate atomic writes")
>> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
>> Signed-off-by: Chris Mason <mason@kernel.org>
>
> Sashiko caught an issue on this patch (and some of the next ones) worth
> investigating in depth.
>
> In this one it says it may cause ext4 to silently convert an atomic
> write into a buffered non-atomic. I know that ext4 tends to move from
> DIO to buffered IO by default, but silently dropping atomic doesn't seem
> right in this case.
>
> Looking through the report and the code it indeed seems a valid
> possibility in some FS configurations as ext4_dio_alignment checks may
> cause ext4_should_use_dio to return false (dio_align == 0 cases).
>
> Giving ext4's special fallback, perhaps just leave the
> generic_atomic_write_valid check in place for ext4?

This was actually in the notes and I didn't follow up on it, sorry.

Claude suggests Tal Zussman's (cc'd) patch:

https://lore.kernel.org/all/20261012-ext4-atomic-no-fallback-v2-1-c4b30c60e500@columbia.edu/

Which fixes these cases and is already reviewed by Jan.

Carlos's suggestion also fixes sashiko's bug, but leaves open
the (pre-existing) bug where the offset is ignored in O_APPEND
ATOMIC math.

Last option is to just duplicate Tal's related hunk (below), that's
my least favorite.

Ted?

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6750d46fe31c..32c789fb2982 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -612,6 +612,9 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			inode_unlock_shared(inode);
 		else
 			inode_unlock(inode);
+		/* There is no support for atomic writes on buffered-io yet. */
+		if (iocb->ki_flags & IOCB_ATOMIC)
+			return -EOPNOTSUPP;
 		return ext4_buffered_write_iter(iocb, from);
 	}
 
