Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794428969;
	b=qdh/INyWPpRHWzxfYM7nBZC/bTB3FWrX/NyHrFfpuoOkoL1ckxJloTV+Iz2RuDpQCLxL
	 ZWLmCIeh/ymei3oXEpKwIo3PARo4NovuMiXwuX3MYoErvx7AFYmMW4SSPqZSpIVrzLixA
	 z4VAcWDeh1DDOUoPrTlnEnl8RE3RszpbeCDOVMY49hygBIbrJpESvUsit6zy6ow0e0cTN
	 0J/rUsLXttna0gOropsEWvq6AKbFpAB5oydpvy2M7ZSGID1PPCh055DcXDZJmYNycbcQj
	 uiX8d/dCOO3ldZLq6PKMcc5nDwfCu8dXdGiJLaAchtWcL2dCC6po2HgUQqmZgoCeRig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794428969;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=nRvkZ+ACteYQfc63ORXLsuGc1uNjx5FP0xtY7kaZLaI=;
	b=UmwJv5qUyezZrkMHd1YQd+xJNtpSykrnd5KmHMO+G2fbK/a918jkQ6ofIiyQZHtVISHL
	 zMC+fwA8dxEYPf/FVlXIMGW4XhKxJ84SC6MCOKxdK7y34QOH3yundFfiPBwpVBtc7ZwF4
	 a3dtuJqYrstLPfsdMc6LU+AFzzTzlC07IwsKz8szxJzaq+sZfw9PWMnxmt7KKk55Mogs5
	 1HsENAcdhkl5h6XYTU353opEwA8y9WNxx51ZdkYdDxKLyUOy/yvXfZ5alfud0F/0K0bPf
	 HZBBULu5oNIRycYRE7DXDdl7/kkwhs9kwF6wLskHNUYJAMc9heBIprgDJSpZKnhAYeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=QVPIxsOg;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE3C606A327
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 20:29:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DE3C606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=QVPIxsOg
DKIM2-Signature:  i=1; m=1; t=1794428961;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
 d=gmx.com;
 s=s31663417:rsa-sha256:kq3Gy4qq+mar6z7y7GVaf9t9Zho6
   18kND+nlQaytQywFjeVnIySa6y+iMvz+dOzeEtGWea0BJjn0a0KaeTLTe26DFkg5QNBsgkshRTw
   hJwcDEbTCORQYPrc60l4k8V6e1tuwRGpU8jii5X/uPdcfw19uDw4EJaQgruWBNXihayHxVdpy7B
   +22MopjIDlqVOD5lbVkvONApXWExHz2FiRFwQIudd8FJ8b3HtKvGsEXGnNck06vjMeropsD2rm5
   vC0KFciy8FhFl+HkW7GU72Hmv9HPXW1TYq/hOx2EvTApgtxZUiUYgOSyIMfLCb3oStCXkbpjLgP
   F6Tl23xus9hlog==;
Message-Instance:  m=1;
 h=sha256:
   ygL0TYOA7nu5Spj4CKlsGz7Q0oDcXCThWRiD7eVdrnc=:
   LffjWquZWglmtHsGSdk+eUHQ20LImYMfUTjCQ2rfil0=,
  sha512:
   1UvPs1dbiW1jO9okaglpdLRBFdZ1DO8xL0a4cWHnj/u+LpU0qQs35zDqFt9agNW0VU10KU7pvzZMvlXfCfEkzw==:
   3FmPbtwjtEXUUKEKBeOhO7Q2ZtzQyl7WiGz/90Nb546ISP1jcjwPIRSRNpLg5ztNXF0ndsN4/biCUS9KDI/3HQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794428936; x=1795033736; i=quwenruo.btrfs@gmx.com;
	bh=nRvkZ+ACteYQfc63ORXLsuGc1uNjx5FP0xtY7kaZLaI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QVPIxsOgxFKWZOwtGdOb4Ae9nAALEqN1/5cyc+KB+Abb8ZB2yaa+lRWYXPXsUtld
	 WUnjn4dQOW/cAUtaUYZr96kJmN6pzlt3cmgPxD5+rfkio40ofrWWkYD/02OlsJ0LS
	 sZNXTWJjr97cWRjOYp0Ibuy8699xOkKlYY0gtBU7AAsm+o6IMEOSE9nBogJXqNsMD
	 3inJY8N+jPhldKN+NDgyiBZtjwHBghz68cg05qBpiLMjcbp3fqcnnfxDEgE19pY3c
	 JHpR57tVNa4AoChH21toSRjPPr/hdTARPTVOCGAwL6e5BFA21ceoN5io83kQPSHxP
	 3ilU+yAWY4Tt164t6Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MUXtY-1x0o8U2uAa-00S2z0; Wed, 11
 Nov 2026 21:28:56 +0100
Message-ID: <a3dfd1f0-2347-4c1c-8b1c-93a8e0d81a73@gmx.com>
Date: Thu, 12 Nov 2026 06:58:48 +1030
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: good crcs in userspace, Re: [PATCH v2 2/7] btrfs-progs:
 crypto/crc32c: port crc32c-pcl optimization to C
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 Anuj Gupta <anuj20.g@samsung.com>, Eric Biggers <ebiggers@kernel.org>
References: <cover.1794196688.git.wqu@suse.com>
 <d2e7c1e242aa07869660461a1913ed7e771db49e.1794196688.git.wqu@suse.com>
 <avSeoCUnOOJT5A65@infradead.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <avSeoCUnOOJT5A65@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Lid7Po6wxZ40OrSX7B455Ju4TaDEFWx51arILh/dUkda2N0VVib
 tKgw6xbqSuOm56svWGnaeJcXgl2CMrvFNcLfSD9HnMNTWihL5wYjKNfgbLOuPePXBg3nsB/
 51fHlN5fXs0paZUSeyaxgjRP2vIuwEa4rZow0OSFjae6CA7Jy85K7q0n6kRXzFlzzWOq0ga
 May9PG9I362CVYwCYc6rA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Fyvx6DMaa14=;b8A2goRV59kBJ1jSl2akxapcvdT
 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
 CeiY76HaKEJZ+qo/qfx+IAt5kHrZU8=



=E5=9C=A8 2026/11/12 03:28, Christoph Hellwig =E5=86=99=E9=81=93:
> Hi Qu,
>=20
> trying to hijack this a bit.  We have a few uses for crcs in userspace.
> Your btrfs code, libxfs which already has a very unoptimized crc32c and
> I recently added a similarly basic crc64.  For PI passthrough through
> I/O uring we need crc16, crc32c and crc64, and I plan to also extend
> this to file system checksums though io_uring.
>=20
> I've been wondering what the recommended crc implementation for userspac=
e
> is or should be.  The only google library I found was in c++ so it is
> not very useful.

And it's not that optimized on arm64, at least compared to kernel's ASM:

https://github.com/kdave/btrfs-progs/issues/1035#issuecomment-6721951904

There is also fast-crc project, doing almost exactly what I'm trying to=20
do, pure C with intrinsics, but covers both x86_64 and arm64, and with=20
more fine tuning on the details:

https://github.com/corsix/fast-crc32

>  Intel's ISA-L has fairly optimized implementations,
> but it's a giant messy library doing more than just CRC.  I briefly
> thought about porting the kernel code to userspace, but the conversion
> of kernel static branches to userspace concepts is non-trivial.  Also
> a GPL license might be a bit limiting as a lot of storage software the
> could make good use of it is Apache license.
>=20
> So no good answer on how to do it, but having some really well defined
> library for userspace crc needs would be really neat and better than
> everyone rolling their own.

To be honest, at least on x86_64, I don't think we need to bother that=20
much on hand-writing ASM files to get everything done right.
As most of the time are spent on the vector commands anyway.

So my preferred solution is, let the kernel be the source of portable C=20
optimized code, and copy it to projects that needs it.

But since it's not yet there, I think fast-crc32 would be the best for=20
your refernece. Unfortunately it only covers crc32, no crc16 nor crc64=20
for your use cases.

Thanks,
Qu

>=20
> On Mon, Nov 09, 2026 at 02:39:56PM +1030, Qu Wenruo wrote:
>> This is inspired by Google's CRC32C library which has all the hardware
>> acceleration, but without any ASM code.
>>
>> The idea is to use compiler wrapped commands instead of the hand writte=
n
>> ASM code.
>>
>> The performance is at the same level as the old code:
>>
>> The hardware is Ryzen 9 HX 370, on a single CPU core, unit is GiB/s.
>>
>>     Size    |  Old (asm)  |   New (C)
>> -----------+-------------+-------------
>>   64 B      | 4.76=E2=80=934.80   | 4.80=E2=80=934.82
>>   256 B     | 8.76=E2=80=938.88   | 8.82=E2=80=938.87
>>   1 KiB     | 12.26=E2=80=9312.41 | 12.47=E2=80=9312.51
>>   4 KiB     | 13.35=E2=80=9313.49 | 13.48
>>   16 KiB    | 13.69=E2=80=9313.78 | 13.66=E2=80=9313.79
>>   64 KiB    | 13.73=E2=80=9313.83 | 13.75=E2=80=9313.83
>>   1 MiB     | 13.62=E2=80=9313.72 | 13.61=E2=80=9313.63
>>
>> We should have a better hash-vectest to cover larger block sizes, but
>> that will be added later by the newer ARMv8 CRC optimization.
>>
>> Asssited-by: LLM (code porting, testing)
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   Makefile                         |  14 --
>>   crypto/crc32c-pcl-intel-asm_64.S | 370 ------------------------------=
-
>>   crypto/crc32c.c                  | 262 +++++++++++++++++++++-
>>   3 files changed, 258 insertions(+), 388 deletions(-)
>>   delete mode 100644 crypto/crc32c-pcl-intel-asm_64.S
>>
>> diff --git a/Makefile b/Makefile
>> index 78c23ad3c694..e5a5534b4fb7 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -107,8 +107,6 @@ ENABLE_WARNING_FLAGS :=3D $(call cc-option, -Wimpli=
cit-fallthrough) \
>>   			$(call cc-option, -Wmissing-prototypes) \
>>   			-Wshadow
>>  =20
>> -ASFLAGS =3D
>> -
>>   # Common build flags
>>   CFLAGS =3D $(SUBST_CFLAGS) \
>>   	 -std=3Dgnu11 \
>> @@ -413,11 +411,6 @@ CRYPTO_OBJECTS =3D crypto/sha224-256.o crypto/blak=
e2b-ref.o crypto/blake2b-sse2.o
>>   CRYPTO_CFLAGS =3D -DCRYPTOPROVIDER_BUILTIN=3D1
>>   endif
>>  =20
>> -ifeq ($(TARGET_CPU),x86_64)
>> -CRYPTO_OBJECTS +=3D crypto/crc32c-pcl-intel-asm_64.o
>> -ASFLAGS +=3D -fPIC
>> -endif
>> -
>>   CHECKER_FLAGS +=3D $(btrfs_convert_cflags)
>>  =20
>>   # collect values of the variables above
>> @@ -478,13 +471,6 @@ else
>>   	check_echo =3D true
>>   endif
>>  =20
>> -.S.o:
>> -	@echo "  AS       $@"
>> -	$(Q)$(CC) $(CFLAGS) $(ASFLAGS) -c $< -o $@
>> -
>> -%.static.o: %.S
>> -	@echo "  AS       $@"
>> -	$(Q)$(CC) $(CFLAGS) $(ASFLAGS) -c $< -o $@
>>   #
>>   # Pick from per-file variables, btrfs_*_cflags
>>   #
>> diff --git a/crypto/crc32c-pcl-intel-asm_64.S b/crypto/crc32c-pcl-intel=
-asm_64.S
>> deleted file mode 100644
>> index f87e62bdf345..000000000000
>> --- a/crypto/crc32c-pcl-intel-asm_64.S
>> +++ /dev/null
>> @@ -1,370 +0,0 @@
>> -/*
>> - * Implement fast CRC32C with PCLMULQDQ instructions. (x86_64)
>> - *
>> - * The white papers on CRC32C calculations with PCLMULQDQ instruction =
can be
>> - * downloaded from:
>> - * http://www.intel.com/content/dam/www/public/us/en/documents/white-p=
apers/crc-iscsi-polynomial-crc32-instruction-paper.pdf
>> - * http://www.intel.com/content/dam/www/public/us/en/documents/white-p=
apers/fast-crc-computation-paper.pdf
>> - *
>> - * Copyright (C) 2012 Intel Corporation.
>> - * Copyright 2024 Google LLC
>> - *
>> - * Authors:
>> - *	Wajdi Feghali <wajdi.k.feghali@intel.com>
>> - *	James Guilford <james.guilford@intel.com>
>> - *	David Cote <david.m.cote@intel.com>
>> - *	Tim Chen <tim.c.chen@linux.intel.com>
>> - *
>> - * This software is available to you under a choice of one of two
>> - * licenses.  You may choose to be licensed under the terms of the GNU
>> - * General Public License (GPL) Version 2, available from the file
>> - * COPYING in the main directory of this source tree, or the
>> - * OpenIB.org BSD license below:
>> - *
>> - *     Redistribution and use in source and binary forms, with or
>> - *     without modification, are permitted provided that the following
>> - *     conditions are met:
>> - *
>> - *      - Redistributions of source code must retain the above
>> - *        copyright notice, this list of conditions and the following
>> - *        disclaimer.
>> - *
>> - *      - Redistributions in binary form must reproduce the above
>> - *        copyright notice, this list of conditions and the following
>> - *        disclaimer in the documentation and/or other materials
>> - *        provided with the distribution.
>> - *
>> - * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> - * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> - * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> - * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
>> - * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
>> - * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
>> - * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> - * SOFTWARE.
>> - */
>> -
>> -##include "linkage.h"
>> -
>> -#define ENDBR
>> -
>> -## ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction
>> -
>> -# Define threshold below which buffers are considered "small" and rout=
ed to
>> -# regular CRC code that does not interleave the CRC instructions.
>> -#define SMALL_SIZE 200
>> -
>> -# unsigned int crc_pcl(const u8 *buffer, unsigned int len, unsigned in=
t crc_init);
>> -
>> -.text
>> -###SYM_FUNC_START(crc_pcl)
>> -.globl crc_pcl
>> -crc_pcl:
>> -###SYM_FUNC_START(crc_pcl)
>> -#define    bufp		  %rdi
>> -#define    bufp_d	  %edi
>> -#define    len		  %esi
>> -#define    crc_init	  %edx
>> -#define    crc_init_q	  %rdx
>> -#define    n_misaligned	  %ecx /* overlaps chunk_bytes! */
>> -#define    n_misaligned_q %rcx
>> -#define    chunk_bytes	  %ecx /* overlaps n_misaligned! */
>> -#define    chunk_bytes_q  %rcx
>> -#define    crc1		  %r8
>> -#define    crc2		  %r9
>> -
>> -	cmp	$SMALL_SIZE, len
>> -	jb	.Lsmall
>> -
>> -	################################################################
>> -	## 1) ALIGN:
>> -	################################################################
>> -	mov	bufp_d, n_misaligned
>> -	neg	n_misaligned
>> -	and	$7, n_misaligned	# calculate the misalignment amount of
>> -					# the address
>> -	je	.Laligned		# Skip if aligned
>> -
>> -	# Process 1 <=3D n_misaligned <=3D 7 bytes individually in order to a=
lign
>> -	# the remaining data to an 8-byte boundary.
>> -.Ldo_align:
>> -	movq	(bufp), %rax
>> -	add	n_misaligned_q, bufp
>> -	sub	n_misaligned, len
>> -.Lalign_loop:
>> -	crc32b	%al, crc_init		# compute crc32 of 1-byte
>> -	shr	$8, %rax		# get next byte
>> -	dec	n_misaligned
>> -	jne     .Lalign_loop
>> -.Laligned:
>> -
>> -	################################################################
>> -	## 2) PROCESS BLOCK:
>> -	################################################################
>> -
>> -	cmp	$128*24, len
>> -	jae     .Lfull_block
>> -
>> -.Lpartial_block:
>> -	# Compute floor(len / 24) to get num qwords to process from each lane=
.
>> -	imul	$2731, len, %eax	# 2731 =3D ceil(2^16 / 24)
>> -	shr	$16, %eax
>> -	jmp	.Lcrc_3lanes
>> -
>> -.Lfull_block:
>> -	# Processing 128 qwords from each lane.
>> -	mov	$128, %eax
>> -
>> -	################################################################
>> -	## 3) CRC each of three lanes:
>> -	################################################################
>> -
>> -.Lcrc_3lanes:
>> -	xor	crc1,crc1
>> -	xor     crc2,crc2
>> -	mov	%eax, chunk_bytes
>> -	shl	$3, chunk_bytes		# num bytes to process from each lane
>> -	sub	$5, %eax		# 4 for 4x_loop, 1 for special last iter
>> -	jl	.Lcrc_3lanes_4x_done
>> -
>> -	# Unroll the loop by a factor of 4 to reduce the overhead of the loop
>> -	# bookkeeping instructions, which can compete with crc32q for the ALU=
s.
>> -.Lcrc_3lanes_4x_loop:
>> -	crc32q	(bufp), crc_init_q
>> -	crc32q	(bufp,chunk_bytes_q), crc1
>> -	crc32q	(bufp,chunk_bytes_q,2), crc2
>> -	crc32q	8(bufp), crc_init_q
>> -	crc32q	8(bufp,chunk_bytes_q), crc1
>> -	crc32q	8(bufp,chunk_bytes_q,2), crc2
>> -	crc32q	16(bufp), crc_init_q
>> -	crc32q	16(bufp,chunk_bytes_q), crc1
>> -	crc32q	16(bufp,chunk_bytes_q,2), crc2
>> -	crc32q	24(bufp), crc_init_q
>> -	crc32q	24(bufp,chunk_bytes_q), crc1
>> -	crc32q	24(bufp,chunk_bytes_q,2), crc2
>> -	add	$32, bufp
>> -	sub	$4, %eax
>> -	jge	.Lcrc_3lanes_4x_loop
>> -
>> -.Lcrc_3lanes_4x_done:
>> -	add	$4, %eax
>> -	jz	.Lcrc_3lanes_last_qword
>> -
>> -.Lcrc_3lanes_1x_loop:
>> -	crc32q	(bufp), crc_init_q
>> -	crc32q	(bufp,chunk_bytes_q), crc1
>> -	crc32q	(bufp,chunk_bytes_q,2), crc2
>> -	add	$8, bufp
>> -	dec	%eax
>> -	jnz	.Lcrc_3lanes_1x_loop
>> -
>> -.Lcrc_3lanes_last_qword:
>> -	crc32q	(bufp), crc_init_q
>> -	crc32q	(bufp,chunk_bytes_q), crc1
>> -# SKIP  crc32q	(bufp,chunk_bytes_q,2), crc2	; Don't do this one yet
>> -
>> -	################################################################
>> -	## 4) Combine three results:
>> -	################################################################
>> -
>> -	lea	(K_table-8)(%rip), %rax		# first entry is for idx 1
>> -	pmovzxdq (%rax,chunk_bytes_q), %xmm0	# 2 consts: K1:K2
>> -	lea	(chunk_bytes,chunk_bytes,2), %eax # chunk_bytes * 3
>> -	sub	%eax, len			# len -=3D chunk_bytes * 3
>> -
>> -	movq	crc_init_q, %xmm1		# CRC for block 1
>> -	pclmulqdq $0x00, %xmm0, %xmm1		# Multiply by K2
>> -
>> -	movq    crc1, %xmm2			# CRC for block 2
>> -	pclmulqdq $0x10, %xmm0, %xmm2		# Multiply by K1
>> -
>> -	pxor    %xmm2,%xmm1
>> -	movq    %xmm1, %rax
>> -	xor	(bufp,chunk_bytes_q,2), %rax
>> -	mov	crc2, crc_init_q
>> -	crc32	%rax, crc_init_q
>> -	lea	8(bufp,chunk_bytes_q,2), bufp
>> -
>> -	################################################################
>> -	## 5) If more blocks remain, goto (2):
>> -	################################################################
>> -
>> -	cmp	$128*24, len
>> -	jae	.Lfull_block
>> -	cmp	$SMALL_SIZE, len
>> -	jae	.Lpartial_block
>> -
>> -	#####################################################################=
##
>> -	## 6) Process any remainder without interleaving:
>> -	#####################################################################=
##
>> -.Lsmall:
>> -	test	len, len
>> -	jz	.Ldone
>> -	mov	len, %eax
>> -	shr	$3, %eax
>> -	jz	.Ldo_dword
>> -.Ldo_qwords:
>> -	crc32q	(bufp), crc_init_q
>> -	add	$8, bufp
>> -	dec	%eax
>> -	jnz	.Ldo_qwords
>> -.Ldo_dword:
>> -	test	$4, len
>> -	jz	.Ldo_word
>> -	crc32l	(bufp), crc_init
>> -	add	$4, bufp
>> -.Ldo_word:
>> -	test	$2, len
>> -	jz	.Ldo_byte
>> -	crc32w	(bufp), crc_init
>> -	add	$2, bufp
>> -.Ldo_byte:
>> -	test	$1, len
>> -	jz	.Ldone
>> -	crc32b	(bufp), crc_init
>> -.Ldone:
>> -	mov	crc_init, %eax
>> -        RET
>> -###SYM_FUNC_END(crc_pcl)
>> -.size crc_pcl, .-crc_pcl
>> -###SYM_FUNC_END(crc_pcl)
>> -
>> -.data
>> -	################################################################
>> -	## PCLMULQDQ tables
>> -	## Table is 128 entries x 2 words (8 bytes) each
>> -	################################################################
>> -.section	.rodata, "a", @progbits
>> -.align 8
>> -K_table:
>> -	.long 0x493c7d27, 0x00000001
>> -	.long 0xba4fc28e, 0x493c7d27
>> -	.long 0xddc0152b, 0xf20c0dfe
>> -	.long 0x9e4addf8, 0xba4fc28e
>> -	.long 0x39d3b296, 0x3da6d0cb
>> -	.long 0x0715ce53, 0xddc0152b
>> -	.long 0x47db8317, 0x1c291d04
>> -	.long 0x0d3b6092, 0x9e4addf8
>> -	.long 0xc96cfdc0, 0x740eef02
>> -	.long 0x878a92a7, 0x39d3b296
>> -	.long 0xdaece73e, 0x083a6eec
>> -	.long 0xab7aff2a, 0x0715ce53
>> -	.long 0x2162d385, 0xc49f4f67
>> -	.long 0x83348832, 0x47db8317
>> -	.long 0x299847d5, 0x2ad91c30
>> -	.long 0xb9e02b86, 0x0d3b6092
>> -	.long 0x18b33a4e, 0x6992cea2
>> -	.long 0xb6dd949b, 0xc96cfdc0
>> -	.long 0x78d9ccb7, 0x7e908048
>> -	.long 0xbac2fd7b, 0x878a92a7
>> -	.long 0xa60ce07b, 0x1b3d8f29
>> -	.long 0xce7f39f4, 0xdaece73e
>> -	.long 0x61d82e56, 0xf1d0f55e
>> -	.long 0xd270f1a2, 0xab7aff2a
>> -	.long 0xc619809d, 0xa87ab8a8
>> -	.long 0x2b3cac5d, 0x2162d385
>> -	.long 0x65863b64, 0x8462d800
>> -	.long 0x1b03397f, 0x83348832
>> -	.long 0xebb883bd, 0x71d111a8
>> -	.long 0xb3e32c28, 0x299847d5
>> -	.long 0x064f7f26, 0xffd852c6
>> -	.long 0xdd7e3b0c, 0xb9e02b86
>> -	.long 0xf285651c, 0xdcb17aa4
>> -	.long 0x10746f3c, 0x18b33a4e
>> -	.long 0xc7a68855, 0xf37c5aee
>> -	.long 0x271d9844, 0xb6dd949b
>> -	.long 0x8e766a0c, 0x6051d5a2
>> -	.long 0x93a5f730, 0x78d9ccb7
>> -	.long 0x6cb08e5c, 0x18b0d4ff
>> -	.long 0x6b749fb2, 0xbac2fd7b
>> -	.long 0x1393e203, 0x21f3d99c
>> -	.long 0xcec3662e, 0xa60ce07b
>> -	.long 0x96c515bb, 0x8f158014
>> -	.long 0xe6fc4e6a, 0xce7f39f4
>> -	.long 0x8227bb8a, 0xa00457f7
>> -	.long 0xb0cd4768, 0x61d82e56
>> -	.long 0x39c7ff35, 0x8d6d2c43
>> -	.long 0xd7a4825c, 0xd270f1a2
>> -	.long 0x0ab3844b, 0x00ac29cf
>> -	.long 0x0167d312, 0xc619809d
>> -	.long 0xf6076544, 0xe9adf796
>> -	.long 0x26f6a60a, 0x2b3cac5d
>> -	.long 0xa741c1bf, 0x96638b34
>> -	.long 0x98d8d9cb, 0x65863b64
>> -	.long 0x49c3cc9c, 0xe0e9f351
>> -	.long 0x68bce87a, 0x1b03397f
>> -	.long 0x57a3d037, 0x9af01f2d
>> -	.long 0x6956fc3b, 0xebb883bd
>> -	.long 0x42d98888, 0x2cff42cf
>> -	.long 0x3771e98f, 0xb3e32c28
>> -	.long 0xb42ae3d9, 0x88f25a3a
>> -	.long 0x2178513a, 0x064f7f26
>> -	.long 0xe0ac139e, 0x4e36f0b0
>> -	.long 0x170076fa, 0xdd7e3b0c
>> -	.long 0x444dd413, 0xbd6f81f8
>> -	.long 0x6f345e45, 0xf285651c
>> -	.long 0x41d17b64, 0x91c9bd4b
>> -	.long 0xff0dba97, 0x10746f3c
>> -	.long 0xa2b73df1, 0x885f087b
>> -	.long 0xf872e54c, 0xc7a68855
>> -	.long 0x1e41e9fc, 0x4c144932
>> -	.long 0x86d8e4d2, 0x271d9844
>> -	.long 0x651bd98b, 0x52148f02
>> -	.long 0x5bb8f1bc, 0x8e766a0c
>> -	.long 0xa90fd27a, 0xa3c6f37a
>> -	.long 0xb3af077a, 0x93a5f730
>> -	.long 0x4984d782, 0xd7c0557f
>> -	.long 0xca6ef3ac, 0x6cb08e5c
>> -	.long 0x234e0b26, 0x63ded06a
>> -	.long 0xdd66cbbb, 0x6b749fb2
>> -	.long 0x4597456a, 0x4d56973c
>> -	.long 0xe9e28eb4, 0x1393e203
>> -	.long 0x7b3ff57a, 0x9669c9df
>> -	.long 0xc9c8b782, 0xcec3662e
>> -	.long 0x3f70cc6f, 0xe417f38a
>> -	.long 0x93e106a4, 0x96c515bb
>> -	.long 0x62ec6c6d, 0x4b9e0f71
>> -	.long 0xd813b325, 0xe6fc4e6a
>> -	.long 0x0df04680, 0xd104b8fc
>> -	.long 0x2342001e, 0x8227bb8a
>> -	.long 0x0a2a8d7e, 0x5b397730
>> -	.long 0x6d9a4957, 0xb0cd4768
>> -	.long 0xe8b6368b, 0xe78eb416
>> -	.long 0xd2c3ed1a, 0x39c7ff35
>> -	.long 0x995a5724, 0x61ff0e01
>> -	.long 0x9ef68d35, 0xd7a4825c
>> -	.long 0x0c139b31, 0x8d96551c
>> -	.long 0xf2271e60, 0x0ab3844b
>> -	.long 0x0b0bf8ca, 0x0bf80dd2
>> -	.long 0x2664fd8b, 0x0167d312
>> -	.long 0xed64812d, 0x8821abed
>> -	.long 0x02ee03b2, 0xf6076544
>> -	.long 0x8604ae0f, 0x6a45d2b2
>> -	.long 0x363bd6b3, 0x26f6a60a
>> -	.long 0x135c83fd, 0xd8d26619
>> -	.long 0x5fabe670, 0xa741c1bf
>> -	.long 0x35ec3279, 0xde87806c
>> -	.long 0x00bcf5f6, 0x98d8d9cb
>> -	.long 0x8ae00689, 0x14338754
>> -	.long 0x17f27698, 0x49c3cc9c
>> -	.long 0x58ca5f00, 0x5bd2011f
>> -	.long 0xaa7c7ad5, 0x68bce87a
>> -	.long 0xb5cfca28, 0xdd07448e
>> -	.long 0xded288f8, 0x57a3d037
>> -	.long 0x59f229bc, 0xdde8f5b9
>> -	.long 0x6d390dec, 0x6956fc3b
>> -	.long 0x37170390, 0xa3e3e02c
>> -	.long 0x6353c1cc, 0x42d98888
>> -	.long 0xc4584f5c, 0xd73c7bea
>> -	.long 0xf48642e9, 0x3771e98f
>> -	.long 0x531377e2, 0x80ff0093
>> -	.long 0xdd35bc8d, 0xb42ae3d9
>> -	.long 0xb25b29f2, 0x8fe4c34d
>> -	.long 0x9a5ede41, 0x2178513a
>> -	.long 0xa563905d, 0xdf99fc11
>> -	.long 0x45cddf4e, 0xe0ac139e
>> -	.long 0xacfa3103, 0x6c23e841
>> -	.long 0xa51b6135, 0x170076fa
>> -
>> -## Warning
>> -.section .note.GNU-stack,"",@progbits
>> diff --git a/crypto/crc32c.c b/crypto/crc32c.c
>> index 9a3c9fc14eab..daf232c44e4d 100644
>> --- a/crypto/crc32c.c
>> +++ b/crypto/crc32c.c
>> @@ -10,6 +10,7 @@
>>  =20
>>   #include <inttypes.h>
>>   #include <stdio.h>
>> +#include <string.h>
>>   #include "crypto/crc32c.h"
>>   #include "common/cpu-utils.h"
>>  =20
>> @@ -19,10 +20,262 @@ static uint32_t (*crc32c_impl)(uint32_t crc, unsig=
ned char const *data, uint32_t
>>   #ifdef __x86_64__
>>  =20
>>   #include <nmmintrin.h>
>> +#include <wmmintrin.h>
>>  =20
>> -/* asmlinkage */ unsigned int crc_pcl(const unsigned char *buffer, uns=
igned int len, unsigned int crc_init);
>> -static unsigned int crc32c_pcl(uint32_t crc, unsigned char const *data=
, uint32_t len) {
>> -	return crc_pcl(data, len, crc);
>> +/*
>> + * Fast CRC32C with PCLMULQDQ, three interleaved crc32 lanes combined =
with
>> + * carry-less multiplication. Derived from the Intel implementation
>> + * (crc32c-pcl-intel-asm_64.S in the kernel), available under GPLv2 or=
 the
>> + * OpenIB.org BSD license.
>> + *
>> + * Copyright (C) 2012 Intel Corporation.
>> + * Copyright 2024 Google LLC
>> + *
>> + * Authors:
>> + *	Wajdi Feghali <wajdi.k.feghali@intel.com>
>> + *	James Guilford <james.guilford@intel.com>
>> + *	David Cote <david.m.cote@intel.com>
>> + *	Tim Chen <tim.c.chen@linux.intel.com>
>> + */
>> +
>> +/* ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction */
>> +
>> +/*
>> + * Define threshold below which buffers are considered "small" and rou=
ted to
>> + * regular CRC code that does not interleave the CRC instructions.
>> + */
>> +#define PCL_SMALL_SIZE	200
>> +
>> +/*
>> + * PCLMULQDQ tables
>> + * Table is 128 entries x 2 words (8 bytes) each. The first entry is f=
or idx 1
>> + * (one qword per lane), the constants are used as K1:K2 when combinin=
g lanes.
>> + */
>> +static const uint32_t crc32c_pcl_k_table[128][2] =3D {
>> +	{ 0x493c7d27, 0x00000001 },
>> +	{ 0xba4fc28e, 0x493c7d27 },
>> +	{ 0xddc0152b, 0xf20c0dfe },
>> +	{ 0x9e4addf8, 0xba4fc28e },
>> +	{ 0x39d3b296, 0x3da6d0cb },
>> +	{ 0x0715ce53, 0xddc0152b },
>> +	{ 0x47db8317, 0x1c291d04 },
>> +	{ 0x0d3b6092, 0x9e4addf8 },
>> +	{ 0xc96cfdc0, 0x740eef02 },
>> +	{ 0x878a92a7, 0x39d3b296 },
>> +	{ 0xdaece73e, 0x083a6eec },
>> +	{ 0xab7aff2a, 0x0715ce53 },
>> +	{ 0x2162d385, 0xc49f4f67 },
>> +	{ 0x83348832, 0x47db8317 },
>> +	{ 0x299847d5, 0x2ad91c30 },
>> +	{ 0xb9e02b86, 0x0d3b6092 },
>> +	{ 0x18b33a4e, 0x6992cea2 },
>> +	{ 0xb6dd949b, 0xc96cfdc0 },
>> +	{ 0x78d9ccb7, 0x7e908048 },
>> +	{ 0xbac2fd7b, 0x878a92a7 },
>> +	{ 0xa60ce07b, 0x1b3d8f29 },
>> +	{ 0xce7f39f4, 0xdaece73e },
>> +	{ 0x61d82e56, 0xf1d0f55e },
>> +	{ 0xd270f1a2, 0xab7aff2a },
>> +	{ 0xc619809d, 0xa87ab8a8 },
>> +	{ 0x2b3cac5d, 0x2162d385 },
>> +	{ 0x65863b64, 0x8462d800 },
>> +	{ 0x1b03397f, 0x83348832 },
>> +	{ 0xebb883bd, 0x71d111a8 },
>> +	{ 0xb3e32c28, 0x299847d5 },
>> +	{ 0x064f7f26, 0xffd852c6 },
>> +	{ 0xdd7e3b0c, 0xb9e02b86 },
>> +	{ 0xf285651c, 0xdcb17aa4 },
>> +	{ 0x10746f3c, 0x18b33a4e },
>> +	{ 0xc7a68855, 0xf37c5aee },
>> +	{ 0x271d9844, 0xb6dd949b },
>> +	{ 0x8e766a0c, 0x6051d5a2 },
>> +	{ 0x93a5f730, 0x78d9ccb7 },
>> +	{ 0x6cb08e5c, 0x18b0d4ff },
>> +	{ 0x6b749fb2, 0xbac2fd7b },
>> +	{ 0x1393e203, 0x21f3d99c },
>> +	{ 0xcec3662e, 0xa60ce07b },
>> +	{ 0x96c515bb, 0x8f158014 },
>> +	{ 0xe6fc4e6a, 0xce7f39f4 },
>> +	{ 0x8227bb8a, 0xa00457f7 },
>> +	{ 0xb0cd4768, 0x61d82e56 },
>> +	{ 0x39c7ff35, 0x8d6d2c43 },
>> +	{ 0xd7a4825c, 0xd270f1a2 },
>> +	{ 0x0ab3844b, 0x00ac29cf },
>> +	{ 0x0167d312, 0xc619809d },
>> +	{ 0xf6076544, 0xe9adf796 },
>> +	{ 0x26f6a60a, 0x2b3cac5d },
>> +	{ 0xa741c1bf, 0x96638b34 },
>> +	{ 0x98d8d9cb, 0x65863b64 },
>> +	{ 0x49c3cc9c, 0xe0e9f351 },
>> +	{ 0x68bce87a, 0x1b03397f },
>> +	{ 0x57a3d037, 0x9af01f2d },
>> +	{ 0x6956fc3b, 0xebb883bd },
>> +	{ 0x42d98888, 0x2cff42cf },
>> +	{ 0x3771e98f, 0xb3e32c28 },
>> +	{ 0xb42ae3d9, 0x88f25a3a },
>> +	{ 0x2178513a, 0x064f7f26 },
>> +	{ 0xe0ac139e, 0x4e36f0b0 },
>> +	{ 0x170076fa, 0xdd7e3b0c },
>> +	{ 0x444dd413, 0xbd6f81f8 },
>> +	{ 0x6f345e45, 0xf285651c },
>> +	{ 0x41d17b64, 0x91c9bd4b },
>> +	{ 0xff0dba97, 0x10746f3c },
>> +	{ 0xa2b73df1, 0x885f087b },
>> +	{ 0xf872e54c, 0xc7a68855 },
>> +	{ 0x1e41e9fc, 0x4c144932 },
>> +	{ 0x86d8e4d2, 0x271d9844 },
>> +	{ 0x651bd98b, 0x52148f02 },
>> +	{ 0x5bb8f1bc, 0x8e766a0c },
>> +	{ 0xa90fd27a, 0xa3c6f37a },
>> +	{ 0xb3af077a, 0x93a5f730 },
>> +	{ 0x4984d782, 0xd7c0557f },
>> +	{ 0xca6ef3ac, 0x6cb08e5c },
>> +	{ 0x234e0b26, 0x63ded06a },
>> +	{ 0xdd66cbbb, 0x6b749fb2 },
>> +	{ 0x4597456a, 0x4d56973c },
>> +	{ 0xe9e28eb4, 0x1393e203 },
>> +	{ 0x7b3ff57a, 0x9669c9df },
>> +	{ 0xc9c8b782, 0xcec3662e },
>> +	{ 0x3f70cc6f, 0xe417f38a },
>> +	{ 0x93e106a4, 0x96c515bb },
>> +	{ 0x62ec6c6d, 0x4b9e0f71 },
>> +	{ 0xd813b325, 0xe6fc4e6a },
>> +	{ 0x0df04680, 0xd104b8fc },
>> +	{ 0x2342001e, 0x8227bb8a },
>> +	{ 0x0a2a8d7e, 0x5b397730 },
>> +	{ 0x6d9a4957, 0xb0cd4768 },
>> +	{ 0xe8b6368b, 0xe78eb416 },
>> +	{ 0xd2c3ed1a, 0x39c7ff35 },
>> +	{ 0x995a5724, 0x61ff0e01 },
>> +	{ 0x9ef68d35, 0xd7a4825c },
>> +	{ 0x0c139b31, 0x8d96551c },
>> +	{ 0xf2271e60, 0x0ab3844b },
>> +	{ 0x0b0bf8ca, 0x0bf80dd2 },
>> +	{ 0x2664fd8b, 0x0167d312 },
>> +	{ 0xed64812d, 0x8821abed },
>> +	{ 0x02ee03b2, 0xf6076544 },
>> +	{ 0x8604ae0f, 0x6a45d2b2 },
>> +	{ 0x363bd6b3, 0x26f6a60a },
>> +	{ 0x135c83fd, 0xd8d26619 },
>> +	{ 0x5fabe670, 0xa741c1bf },
>> +	{ 0x35ec3279, 0xde87806c },
>> +	{ 0x00bcf5f6, 0x98d8d9cb },
>> +	{ 0x8ae00689, 0x14338754 },
>> +	{ 0x17f27698, 0x49c3cc9c },
>> +	{ 0x58ca5f00, 0x5bd2011f },
>> +	{ 0xaa7c7ad5, 0x68bce87a },
>> +	{ 0xb5cfca28, 0xdd07448e },
>> +	{ 0xded288f8, 0x57a3d037 },
>> +	{ 0x59f229bc, 0xdde8f5b9 },
>> +	{ 0x6d390dec, 0x6956fc3b },
>> +	{ 0x37170390, 0xa3e3e02c },
>> +	{ 0x6353c1cc, 0x42d98888 },
>> +	{ 0xc4584f5c, 0xd73c7bea },
>> +	{ 0xf48642e9, 0x3771e98f },
>> +	{ 0x531377e2, 0x80ff0093 },
>> +	{ 0xdd35bc8d, 0xb42ae3d9 },
>> +	{ 0xb25b29f2, 0x8fe4c34d },
>> +	{ 0x9a5ede41, 0x2178513a },
>> +	{ 0xa563905d, 0xdf99fc11 },
>> +	{ 0x45cddf4e, 0xe0ac139e },
>> +	{ 0xacfa3103, 0x6c23e841 },
>> +	{ 0xa51b6135, 0x170076fa },
>> +};
>> +
>> +static inline uint64_t crc32c_load64(const unsigned char *p)
>> +{
>> +	uint64_t v;
>> +
>> +	memcpy(&v, p, sizeof(v));
>> +	return v;
>> +}
>> +
>> +__attribute__((target("sse4.2,pclmul")))
>> +static uint32_t crc32c_pcl(uint32_t crc, unsigned char const *data, ui=
nt32_t len)
>> +{
>> +	uint64_t crc0 =3D crc;
>> +
>> +	if (len >=3D PCL_SMALL_SIZE) {
>> +		unsigned int misaligned =3D -(uintptr_t)data & 7;
>> +
>> +		/*
>> +		 * 1) ALIGN:
>> +		 * Process 1 <=3D misaligned <=3D 7 bytes individually in order to
>> +		 * align the remaining data to an 8-byte boundary.
>> +		 */
>> +		len -=3D misaligned;
>> +		while (misaligned--)
>> +			crc0 =3D _mm_crc32_u8(crc0, *data++);
>> +	}
>> +
>> +	/*
>> +	 * 2) PROCESS BLOCK:
>> +	 * 5) If more blocks remain, repeat from here.
>> +	 */
>> +	while (len >=3D PCL_SMALL_SIZE) {
>> +		/*
>> +		 * Processing 128 qwords from each lane for a full block,
>> +		 * otherwise compute floor(len / 24) to get the number of qwords
>> +		 * to process from each lane. 2731 =3D ceil(2^16 / 24)
>> +		 */
>> +		unsigned int qwords =3D len >=3D 128 * 24 ? 128 : (len * 2731) >> 16=
;
>> +		unsigned int chunk =3D qwords * 8;
>> +		const uint32_t *k =3D crc32c_pcl_k_table[qwords - 1];
>> +		const unsigned char *p1 =3D data + chunk;
>> +		const unsigned char *p2 =3D data + 2 * chunk;
>> +		uint64_t crc1 =3D 0, crc2 =3D 0;
>> +		__m128i kvec, x1, x2;
>> +		unsigned int i;
>> +
>> +		/* 3) CRC each of three lanes: */
>> +		for (i =3D 0; i < qwords - 1; i++) {
>> +			crc0 =3D _mm_crc32_u64(crc0, crc32c_load64(data + i * 8));
>> +			crc1 =3D _mm_crc32_u64(crc1, crc32c_load64(p1 + i * 8));
>> +			crc2 =3D _mm_crc32_u64(crc2, crc32c_load64(p2 + i * 8));
>> +		}
>> +		crc0 =3D _mm_crc32_u64(crc0, crc32c_load64(data + i * 8));
>> +		crc1 =3D _mm_crc32_u64(crc1, crc32c_load64(p1 + i * 8));
>> +		/* SKIP the last qword of crc2, don't do this one yet */
>> +
>> +		/* 4) Combine three results: */
>> +		/* 2 consts: K1:K2 */
>> +		kvec =3D _mm_set_epi64x(k[1], k[0]);
>> +		/* CRC for block 1, multiply by K2 */
>> +		x1 =3D _mm_clmulepi64_si128(_mm_cvtsi64_si128(crc0), kvec, 0x00);
>> +		/* CRC for block 2, multiply by K1 */
>> +		x2 =3D _mm_clmulepi64_si128(_mm_cvtsi64_si128(crc1), kvec, 0x10);
>> +		x1 =3D _mm_xor_si128(x1, x2);
>> +		crc0 =3D _mm_crc32_u64(crc2, _mm_cvtsi128_si64(x1) ^
>> +				     crc32c_load64(p2 + i * 8));
>> +
>> +		data +=3D 3 * chunk;
>> +		len -=3D 3 * chunk;
>> +	}
>> +
>> +	/* 6) Process any remainder without interleaving: */
>> +	while (len >=3D 8) {
>> +		crc0 =3D _mm_crc32_u64(crc0, crc32c_load64(data));
>> +		data +=3D 8;
>> +		len -=3D 8;
>> +	}
>> +	if (len & 4) {
>> +		uint32_t v;
>> +
>> +		memcpy(&v, data, sizeof(v));
>> +		crc0 =3D _mm_crc32_u32(crc0, v);
>> +		data +=3D 4;
>> +	}
>> +	if (len & 2) {
>> +		uint16_t v;
>> +
>> +		memcpy(&v, data, sizeof(v));
>> +		crc0 =3D _mm_crc32_u16(crc0, v);
>> +		data +=3D 2;
>> +	}
>> +	if (len & 1)
>> +		crc0 =3D _mm_crc32_u8(crc0, *data);
>> +
>> +	return crc0;
>>   }
>>  =20
>>   /*
>> @@ -82,7 +335,8 @@ static uint32_t crc32c_sse42(uint32_t crc, unsigned =
char const *data, uint32_t l
>>   void crc32c_init_accel(void)
>>   {
>>   	if (0) {
>> -	} else if (cpu_has_feature(CPU_FLAG_PCLMUL)) {
>> +	} else if (cpu_has_feature(CPU_FLAG_PCLMUL) &&
>> +		   cpu_has_feature(CPU_FLAG_SSE42)) {
>>   		/* printf("CRC32C: pcl\n"); */
>>   		crc32c_impl =3D crc32c_pcl;
>>   	} else if (cpu_has_feature(CPU_FLAG_SSE42)) {
>> --=20
>> 2.56.0
>>
>>
> ---end quoted text---

