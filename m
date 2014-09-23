Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC6E87F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 08:01:26 -0500 (CDT)
Message-ID: <54216F20.1090302@sgi.com>
Date: Tue, 23 Sep 2014 15:01:20 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
In-Reply-To: <87lhpbhfgg.fsf@tassilo.jf.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>, Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, xfs@oss.sgi.com

On 22-09-14 16:55, Andi Kleen wrote:
> Ben Myers <bpm@sgi.com> writes:
>>
>> Strings are normalized using a trie that stores the relevant
>> information.  The trie itself is about 250kB in size, and lives in a
>> separate module.
>
> So 250kB bloat -- and what does this fix exactly?
>
> Someone putting random ligatures into their file names and expecting
> the file to be the same as before. Can't they just not do that?

I like the 'office' example because it is applicable to English and easy to =

explain. Once you move away from English examples are much easier to come =

by. Take a Dutch name like 'Ren=E9e Soutendijk'.

These two forms both spell Ren=E9e in UTF-8:
   0x52 0x65 0x6E 0xC3 0xA9 0x65
   0x52 0x65 0x6E 0x65 0xCC 0x81 0x65
The difference is
  LATIN SMALL LETTER E WITH ACUTE (U+00E9)
  LATIN SMALL LETTER E (U+0065) COMBINING ACUTE ACCENT (U+0301)
and corresponds to the difference between NFC and NFD.

These two forms both spell Soutendijk in UTF-8:
   0x53 0x6F 0x75 0x74 0x65 0x6E 0x64 0x69 0x6A 0x6B
   0x53 0x6F 0x75 0x74 0x65 0x6E 0x64 0xC4 0xB3 0x6B
The difference is
   LATIN SMALL LETTER I (U+0069) LATIN SMALL LETTER J (U+006A)
   LATIN SMALL LIGATURE IJ (U+0133)
and the former is the compatibility decomposition of the latter, the 'K' in =

NFKC/NFKD.

Do accented letters count as random ligatures that people should just not u=
se?

The bulk of the table deals with Korean.

Olaf

-- =

Olaf Weber                 SGI               Phone:  +31(0)30-6696796
                            Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-6796
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
