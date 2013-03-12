Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C0597F83
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 09:40:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 297C58F8035
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:40:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8f8oX6ShBLLQKNLY for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 07:40:17 -0700 (PDT)
Message-ID: <513F3E51.7000600@sandeen.net>
Date: Tue, 12 Mar 2013 09:40:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
	<CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
	<5130DB54.9030503@sandeen.net>
	<CANU9nTkekrw2mdptFdK2RVUFXD=evt0sTZhB9VL+PKY8DTj11A@mail.gmail.com>
	<5134BBA4.3060305@sandeen.net>
	<CANU9nTntXh5spRYc80OhsBqgLnZcJGA2qBeVVQaywthD1RMu4w@mail.gmail.com>
	<513A4AEC.4010202@sandeen.net>
	<CANU9nTnLe76Jm9nYPhoLUZoESfshGyE-RBJ-gkdZZ2Nx3wiC0w@mail.gmail.com>
In-Reply-To: <CANU9nTnLe76Jm9nYPhoLUZoESfshGyE-RBJ-gkdZZ2Nx3wiC0w@mail.gmail.com>
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
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

On 3/12/13 5:41 AM, Ole Tange wrote:
> On Fri, Mar 8, 2013 at 9:32 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 3/8/13 4:21 AM, Ole Tange wrote:
>>> On Mon, Mar 4, 2013 at 4:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>
>>>> 2) so you could run a "real" non-"n" xfs_repair on a metadata image as a more realistic dry run
> :
>>> I get
>>> filenames like:
>>>
>>> /mnt/disk/??5?z+hEOgl/?7?Psr1?aIH<?ip:??/>S??+??z=ozK/8_0/???d)
>>> 5JCG?eiBd?EVsNF'A?v?m?f;Fi6v)d>/?M%?A??J?)B<soGlc??QuY!e-<,6G?
>>> X[Df?Wm^[?f 4|
>>
>> By default, xfs_metadump scrambles filenames, so nothing to worry
>> about (it's for privacy reasons).  If you use the "-o" option it'll keep
>> it in the clear.
> 
> Ahh. To me that does not conform to Principle of Least Astonishment -
> especially since some of the filenames were not obfuscated.
> 
> I would have been less surprised if the files were named:
> 
>     Use_-o_for_real_file_names_XXXXXXXX
>     Use_-o_for_real_dir_names_XXXXXXXX
> 
> where XXXXXXXX is just a unique number.

That would completely change the actual on-disk metadata format,
though, which would defeat the primary purpose of metadump.

As it is, it preserves name lengths and name hashes, so that
what is produced is an accurate representation of the original
filesystem's metadata for analysis.

This is described in the manpage, though I sympathize that
it's a bit alarming the first time you see it in the dump
output, if you weren't aware.

-Eric
 
> 
> /Ole
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
