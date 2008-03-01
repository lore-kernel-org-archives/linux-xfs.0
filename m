Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Mar 2008 13:02:01 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m21L1dxl014791
	for <xfs@oss.sgi.com>; Sat, 1 Mar 2008 13:01:42 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9D3912458ED
	for <xfs@oss.sgi.com>; Sat,  1 Mar 2008 13:02:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id N5bx7nKMaEcBvb55 for <xfs@oss.sgi.com>; Sat, 01 Mar 2008 13:02:06 -0800 (PST)
Message-ID: <47C9C44D.8080400@sandeen.net>
Date: Sat, 01 Mar 2008 15:02:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Kernel oops / XFS filesystem corruption
References: <47C93C32.40006@mathtm.de>
In-Reply-To: <47C93C32.40006@mathtm.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-15?Q?Thomas_M=FCller?= <thomas@mathtm.de>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Thomas Müller wrote:
> Hello :)
> 
> My system just crashed because of a power fluctuation and the root
> filesystem was damaged.
> The system booted up just fine, but when samba tried to start up
> the kernel oops'd.
> 
> xfs_repair was apparently able to repair the damage, though I seem
> to have lost some files.
> 
> I do realize that a lot of awful things can happen if you just cut
> the power, but the kernel shouldn't oops on a mounted file
> system, right?

right.

here's the disassembly of that function in your kernrel FWIW:

0001012c <xfs_attr_shortform_getvalue>:
   1012c:       55                      push   %ebp
   1012d:       57                      push   %edi
   1012e:       56                      push   %esi
   1012f:       53                      push   %ebx
   10130:       89 c3                   mov    %eax,%ebx
   10132:       83 ec 0c                sub    $0xc,%esp
   10135:       8b 40 20                mov    0x20(%eax),%eax
   10138:       8b 40 4c                mov    0x4c(%eax),%eax
   1013b:       8b 40 14                mov    0x14(%eax),%eax
   1013e:       8d 78 04                lea    0x4(%eax),%edi
   10141:       0f b6 40 02             movzbl 0x2(%eax),%eax <--- boom.
   10145:       c7 44 24 08 00 00 00    movl   $0x0,0x8(%esp)
   1014c:       00
   1014d:       89 44 24 04             mov    %eax,0x4(%esp)
   10151:       e9 96 00 00 00          jmp    101ec
<xfs_attr_shortform_getvalue+0xc0>
...

at this point eax is "sf" (0x0) and edi is "sfe" (0x04)

Mar  1 10:32:03 linux kernel: eax: 00000000   ebx: f268cddc   ecx:
f8ae4d9d   edx: 08d26645
Mar  1 10:32:03 linux kernel: esi: f04d1600   edi: 00000004   ebp:
f8ae4d91   esp: f268cdbc

first part of the function:

int
xfs_attr_shortform_getvalue(xfs_da_args_t *args)
{
        xfs_attr_shortform_t *sf;
        xfs_attr_sf_entry_t *sfe;
        int i;

        ASSERT(args->dp->i_d.di_aformat == XFS_IFINLINE);
        sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
        sfe = &sf->list[0];
        for (i = 0; i < sf->hdr.count; <--- died here, sf is 0
                                sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {

we blew up on sf->hdr.count because sf is NULL (hdr.count is 0x2 into sf)

maybe the sgi guys can take it from there ;)  Did you also happen to
save the xfs_repair output?

-Eric
