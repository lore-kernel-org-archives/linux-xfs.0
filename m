Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E53E39FD9
	for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2026 00:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776989538; cv=none; b=InGnE09E7no0biuls2sAEW8I1ThZeioVg3ClRVn0T/SmRZWP4RPQtXsusOMmmnGTJre0Ty5Mw6g9QQnK7J67ZlMaDVNV3eEdr4qwtxdxaJoFX9+q38wvlU4vByLENdwd9vpcjXDRGGVaEdrsGlI5AKTd0BpfGvukCHonnce9lVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776989538; c=relaxed/simple;
	bh=XUklBuxQ2R8t0MQwbgJOYOExxkhn4Qal0gehME6MLIg=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=Ix2oaXHeJ9ZuAz7oOFZv/LK8vGd7dyaqcSVCNP1lCI/S24Rf9oUq18cXABf3wEGnewfd8NN4mE//Ucasinhyc6YgI8ogo1hlaOXRpIYmDYS3eyniIKirIUt208g3rH37wpgzz+90p6MFRj0ovOO4aMFBYSAwwywZREiqvtfvkV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=We0SraTw; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="We0SraTw"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35da01fc0baso4565107a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 23 Apr 2026 17:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776989537; x=1777594337; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/FcUz0voUt4L6VgJUyW4964a1uPVYvz+VsQOTuJZDE4=;
        b=We0SraTwXYHH3GXxeiHH/l8YfN5e1uFRVSTwGSvLC8PYd1/OM1yvtlve9VS7KbO4Ps
         6NZmxBbH52KaxjUrGwfYv7WQ1vSJa90/kzYuEH4OgDVlFyyEqMJp4y4F0YtphkwBvWd4
         iS+5jUnWwbrSxwunc4YPYXgc8jEX7sCz9e8qnEJgwYQyUjUM6flU77X3pAbaNWtyxJ/Y
         iufIcA4GPUn0W3UgnkzdJSiICbysD6Yza6G2D95WSp+Z0L5YtBi5VsEk+Zz5R7GMiy/G
         6gDwCMS3bTlN7DM48IUUr6sciI/KbF9ua6ZBzdJA0MrwFZzwofD2oMi0I9phDS+Jyjll
         gcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776989537; x=1777594337;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FcUz0voUt4L6VgJUyW4964a1uPVYvz+VsQOTuJZDE4=;
        b=LfZhFKvApYZ89a7DLxD58wcp+VwiwScqE3oNKlEVGm20UTdLg8OU/fZ7o7NvQVUfwB
         /1QYvWqta0DGJhEph+eiPGV6dFFVpGoubtJU0qOkia7IjUJgm+Ix9jRavXLtW/PxW5kR
         KJtuEfWuLXcubJuXqNqMgDX3A5CA7Xp+3jwTjMSlrCBhr3PW7PLVV+zlphEGA2ZSBsBX
         V0FCF1pUlJ4chx01LmSw6qlXy3PgcZ+jRVezcAtYzAiRnsorod9ha8ZHnVNf1ANtQz6q
         /kdD4GrROsHGTa/8BxUwpfMOV6lSTWgTJ9gma0NMHdIU59+GZDpnDpM9EbqK/xFkq1KZ
         uyHQ==
X-Gm-Message-State: AOJu0YwGQMAjiQ8guwfpShmBZx8ApPjZ3UXu7cLVlVI2WcrqqSHsijLz
	cY+ILl8UgkINxDmxSpSUH9zCC0TXriJ5EGUjCs+IxzY9FlH+q7vOzz5t
X-Gm-Gg: AeBDietpnLQ5hqYyrIl/hLwfeTYrYg+3ssrOODHGhHnT6vAaXd95qRjqzymfsHBY/4C
	3hvn0MiGjxjCDFJSXD3DMTOiZXPIOIl8Pz5e4uidC203cyT9mkLPG9C1BIAEPtVfs8lzyyIDtyK
	n/IMPNfY11ZMXByxKVQceMOJWXK/+jBIXH9r1GTNHdCJa2Z1AeKCLzLtcF3VD07w76jO3+uf9cG
	tsFqBh18QrGKkjVfTzyi9AD/LnRjVJUg5SupoZkww3uEZgGthalh7Simo8IodgT92WQ174AFuLB
	x6fdXG/hfqbL2JgrUaEQJgS5G/yvykBLkpbwYA7EZVMd63hS4ojWYSLRCBR0m0IGBiv822Q7rJi
	jPPP+6M8Am2QzP9iYSOitX7KB90RoKCXQOaq+HGmDUzMvjDi5u72gRe68F2ipIMbmBnDVyMMEE3
	90Kzp4tS8YD/AXbPF41a2gj9VnNHRl4f31
X-Received: by 2002:a17:903:1ac6:b0:2b0:c90f:44b2 with SMTP id d9443c01a7336-2b5f9e8252bmr308135805ad.12.1776989536590;
        Thu, 23 Apr 2026 17:12:16 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff71esm213485585ad.8.2026.04.23.17.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 17:12:15 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap & xfs
In-Reply-To: <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
Date: Fri, 24 Apr 2026 05:39:23 +0530
Message-ID: <340lte18.ritesh.list@gmail.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

"Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev> writes:

>> 
>> 
>> * Testing Notes (UPDATED) *
>> 
>> - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
>>   xfstests and these patches survive fsx with integrity verification as
>>   well as fsstress parallel stressing.
>> - -g quick with blocks size == page size and blocksize < pagesize shows
>>   no new regressions.
>
> I am hitting a very strange error in generic/127. I deconstructed it in
> to two commands that can reproduce the issue:
>
> ```
> $ dd if=/dev/zero of=/media/test/fsx_lite_nommap bs=262144 count=1
>
> $ /root/home/xfstests/ltp/fsx -l 262144 -o 65536 -S 191110531 -N 100000 -L -R -W /media/test/fsx_lite_nommap
> mapped writes DISABLED
> Seed set to 191110531
> main: filesystem does not support exchange range, disabling!
> main: atomic writes need O_DIRECT (-Z), disabling!
> short read: 0x0 bytes instead of 0x6c7f
> LOG DUMP (1 total operations):
> 1(  1 mod 256): READ     0x39381 thru 0x3ffff   (0x6c7f bytes)
> Log of operations saved to "/media/test/fsx_lite_nommap.fsxops"; replay with --replay-ops
> fsx: save_buffer: .fsxgood file too short... will save 0x0 bytes instead of 0x40000
> : Operation not supported
> Correct content saved for comparison
> (maybe hexdump "/media/test/fsx_lite_nommap" vs "/media/test/fsx_lite_nommap.fsxgood")
> ```


This looks like fsx has a problem where while testing writethrough
support we ftruncate the file size to 0 instead of file_size.

@Ojaswin,

I think we should have it like this I guess.

diff --git a/ltp/fsx.c b/ltp/fsx.c
index c9901f65..3b11b1b5 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2095,7 +2095,7 @@ test_writethrough_io(void)
                return 0;
        }

-       if (ftruncate(fd, 0) != 0) {
+       if (!lite && ftruncate(fd, file_size) != 0) {
                perror("test_writethrough_io: failed to ftruncate to 0\n");
                exit(132);
        }

-ritesh

>
> This is on a bs == ps (4k block size) xfs filesystem.
> ```
> $ xfs_info /media/test/
> meta-data=/dev/nvme1n1           isize=512    agcount=4, agsize=2097152 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=8388608, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> ```
>
> The same test passes if I pass `-G` to fsx parameters(disabling writethrough).
>
> The error is coming when we do a read operation which feels very
> strange. Could you run this in your setup and see if you can reproduce
> them? I still do not know where the issue is coming from or it is
> because of my test setup.
>
> --
> Pankaj
