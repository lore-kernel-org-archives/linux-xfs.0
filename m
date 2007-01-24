Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Jan 2007 15:38:18 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0ONcBqw013516
	for <xfs@oss.sgi.com>; Wed, 24 Jan 2007 15:38:13 -0800
Date: Wed, 24 Jan 2007 18:37:15 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
In-Reply-To: <45B5261B.1050104@redhat.com>
Message-ID: <Pine.LNX.4.64.0701241836590.2930@p34.internal.lan>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan>
 <45B5261B.1050104@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>



On Mon, 22 Jan 2007, Chuck Ebbert wrote:

> Justin Piszcz wrote:
> > My .config is attached, please let me know if any other information is
> > needed and please CC (lkml) as I am not on the list, thanks!
> >
> > Running Kernel 2.6.19.2 on a MD RAID5 volume.  Copying files over Samba to
> > the RAID5 running XFS.
> >
> > Any idea what happened here?
> >
> > [473795.214705] BUG: unable to handle kernel paging request at virtual
> > address fffb92b0
> > [473795.214715]  printing eip:
> > [473795.214718] c0358b14
> > [473795.214721] *pde = 00003067
> > [473795.214723] *pte = 00000000
> > [473795.214726] Oops: 0000 [#1]
> > [473795.214729] PREEMPT SMP [473795.214736] CPU:    0
> > [473795.214737] EIP:    0060:[<c0358b14>]    Not tainted VLI
> > [473795.214738] EFLAGS: 00010286   (2.6.19.2 #1)
> > [473795.214746] EIP is at copy_data+0x6c/0x179
> > [473795.214750] eax: 00000000   ebx: 00001000   ecx: 00000354   edx:
> > fffb9000
> > [473795.214754] esi: fffb92b0   edi: da86c2b0   ebp: 00001000   esp:
> > f7927dc4
> > [473795.214757] ds: 007b   es: 007b   ss: 0068
> > [473795.214761] Process md4_raid5 (pid: 1305, ti=f7926000 task=f7ea9030
> > task.ti=f7926000)
> > [473795.214765] Stack: c1ba7c40 00000003 f5538c80 00000001 da86c000 00000009
> > 00000000 0000006c [473795.214790]        00001000 da8536a8 aa6fee90 f5538c80
> > 00000190 c0358d00 aa6fee88 0000ffff [473795.214863]        d7c5794c 00000001
> > da853488 f6fbec70 f6fbebc0 00000001 00000005 00000001 [473795.214876] Call
> > Trace:
> > [473795.214880]  [<c0358d00>] compute_parity5+0xdf/0x497
> > [473795.214887]  [<c035b0dd>] handle_stripe+0x930/0x2986
> > [473795.214892]  [<c01146b9>] find_busiest_group+0x124/0x4fd
> > [473795.214898]  [<c03580e0>] release_stripe+0x21/0x2e
> > [473795.214902]  [<c035d233>] raid5d+0x100/0x161
> > [473795.214907]  [<c036b03c>] md_thread+0x40/0x103
> > [473795.214912]  [<c012dbbe>] autoremove_wake_function+0x0/0x4b
> > [473795.214917]  [<c036affc>] md_thread+0x0/0x103
> > [473795.214922]  [<c012da1a>] kthread+0xfc/0x100
> > [473795.214926]  [<c012d91e>] kthread+0x0/0x100
> > [473795.214930]  [<c0103b4b>] kernel_thread_helper+0x7/0x1c
> > [473795.214935]  =======================
> > [473795.214938] Code: 14 39 d1 0f 8d 10 01 00 00 89 c8 01 c0 01 c8 01 c0 01
> > c0 89 44 24 1c eb 51 89 d9 c1 e9 02 8b 7c 24 10 01 f7 8b 44 24 18 8d 34 02
> > <f3> a5 89 d9 83 e1 03 74 02 f3 a4 c7 44 24 04 03 00 00 00 89 14
> > [473795.215017] EIP: [<c0358b14>] copy_data+0x6c/0x179 SS:ESP 0068:f7927dc4
> >   
> Without digging too deeply, I'd say you've hit the same bug Sami Farin and
> others
> have reported starting with 2.6.19: pages mapped with kmap_atomic() become
> unmapped
> during memcpy() or similar operations.  Try disabling preempt -- that seems to
> be the
> common factor.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

After I run some other tests, I am going to re-run this test and see if it 
OOPSes again with PREEMPT off.

Justin.
