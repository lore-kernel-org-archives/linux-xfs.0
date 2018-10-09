Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f172.google.com ([209.85.166.172]:55639 "EHLO
        mail-it1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeJJAwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Oct 2018 20:52:03 -0400
Received: by mail-it1-f172.google.com with SMTP id c23-v6so3895963itd.5
        for <linux-xfs@vger.kernel.org>; Tue, 09 Oct 2018 10:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <CABXGCsOxH-gfLL4Mo+RxNk4OoWgAdJzW2Sv2w2He7VkgKxqUug@mail.gmail.com>
 <57e256e5-bcf7-c6ce-601a-64263606d707@sandeen.net>
In-Reply-To: <57e256e5-bcf7-c6ce-601a-64263606d707@sandeen.net>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Tue, 9 Oct 2018 22:33:48 +0500
Message-ID: <CABXGCsNKQn96nPCABmBduF2_EyQXmhSgxgR1ue8MuGQ3acRuAA@mail.gmail.com>
Subject: Re: Which fragmentation factor is allowable for xfs (not impact on performance)?
Content-Type: multipart/mixed; boundary="0000000000009d0ac40577cf24e8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

--0000000000009d0ac40577cf24e8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 7 Oct 2018 at 02:20, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 10/6/18 12:34 PM, Mikhail Gavrilov wrote:
> > Which fragmentation factor is allowable for xfs (not impact on performa=
nce)?
> >
> > # xfs_db -c frag -r /dev/sda
> > actual 4908781, ideal 2801391, fragmentation factor 42.93%
>
> Ignore the fragmentation factor, because:
>
> > Note, this number is largely meaningless.
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.=
27m_over_50.25._Is_that_bad.3F
>
> > Files on this filesystem average 1.75 extents per file
> The majority of your files have only 1 extent.
>
> > # mount | grep sda
> > /dev/sda on /home type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
> >
> > # df -h | grep sda
> > /dev/sda         11T  5.3T  5.7T  49% /home
> >
> > I think it too much for partition which are half free.
>
> Why do you think that?
>
> > It would also be interesting to see the fragmentation in the context
> > of files, but I have not found anywhere how to look at it.
>
> xfs_bmap will show you extent layout for individual files.
>
> -Eric


Thanks I wrote simple bash script for inspect my HDD for top 100
fragmented files.
Here is my top 100:

20511  -  /home/mikhail/.local/share/Steam/steamapps/common/Deus Ex
Mankind Divided/share/data/runtime/game.layer.0.all.archive
18011  -  /home/mikhail/.local/share/Steam/steamapps/common/TEKKEN
7/TekkenGame/Content/Paks/pakchunk0-WindowsNoEditor.pak
16649  -  /home/mikhail/.local/share/Steam/steamapps/common/Wildlands/DataP=
C_GRN_WorldMap.forge
16120  -  /home/mikhail/.local/share/Steam/steamapps/common/Hellblade
Senua's Sacrifice -
VR/HellbladeGame/Content/Paks/HellbladeGame-WindowsNoEditor.pak
14197  -  /home/mikhail/.local/share/Steam/steamapps/common/TEKKEN
7/TekkenGame/Content/Paks/pakchunk1-WindowsNoEditor.pak
12141  -  /home/mikhail/.local/share/Steam/steamapps/common/Wildlands/DataP=
C_GRN_WorldMap_patch_01.forge
9282  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/dlc3.rpkg
8789  -  /home/mikhail/.local/share/Steam/steamapps/common/BLUE
REFLECTION/DATA/PACK00_03.PAK
8455  -  /home/mikhail/.local/share/Steam/steamapps/common/TEKKEN
7/TekkenGame/Content/Paks/pakchunk1-WindowsNoEditor_P.pak
8394  -  /home/mikhail/.local/share/Steam/steamapps/common/Dishonored
2 Demo/base/game2.resources
8234  -  /home/mikhail/.local/share/Steam/steamapps/common/the witcher
2/CookedPC/pack0.dzip
7127  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/dlc1.rpkg
6708  -  /home/mikhail/.local/share/Steam/steamapps/common/Observer/TheObse=
rver/Content/Paks/TheObserver-LinuxNoEditor.pak
6698  -  /home/mikhail/.local/share/Steam/steamapps/common/Wolfenstein.II.T=
he.New.Colossus/base/gameresources.texdb
6691  -  /home/mikhail/.local/share/Steam/steamapps/common/NieRAutomata/dat=
a/data014.cpk
6610  -  /home/mikhail/.local/share/Steam/steamapps/common/Deus Ex
Mankind Divided/share/data/dlc/runtime/dlc01.layer.0.all.archive
6560  -  /home/mikhail/.local/share/Steam/steamapps/common/Dishonored
2 Demo/base/game1.resources
6232  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/chunk0.rpkg
6106  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/dlc5.rpkg
5989  -  /home/mikhail/.local/share/Steam/steamapps/common/Wildlands/DataPC=
.forge
5716  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/dlc2.rpkg
5638  -  /home/mikhail/.local/share/Steam/steamapps/common/Deus Ex
Mankind Divided/share/data/dlc/runtime/dlc02.layer.0.all.archive
5411  -  /home/mikhail/.local/share/Steam/steamapps/common/TheEvilWithin2/v=
irtualtextures/st02_main.pages
5285  -  /home/mikhail/.local/share/Steam/steamapps/common/TheEvilWithin2/v=
irtualtextures/st01_main.pages
5009  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/dlc4.rpkg
4966  -  /home/mikhail/.local/share/Steam/steamapps/common/BLUE
REFLECTION/DATA/PACK00_02.PAK
4813  -  /home/mikhail/.local/share/Steam/steamapps/common/Cyberdimension
Neptunia 4 Goddesses
Online/CyberdimensionNeptunia4GoddessesOnline/Content/Paks/CyberdimensionNe=
ptunia4GoddessesOnline-WindowsNoEditor.pak
4483  -  /home/mikhail/.local/share/Steam/steamapps/common/ShadowOfMordor/s=
hare/data/udun.arch05
4462  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/dlc6.rpkg
4457  -  /home/mikhail/.local/share/Steam/steamapps/common/Call of
Duty WWII/imagefile67.pak
4409  -  /home/mikhail/.local/share/Steam/steamapps/common/Wildlands/PCgr_t=
errainlin1.tbf
4163  -  /home/mikhail/.local/share/Steam/steamapps/common/The Culling
Test/Victory/Content/Paks/Victory-LinuxClient.pak
4091  -  /home/mikhail/.local/share/Steam/steamapps/common/CAT
Interstellar/CATInterstellar/Content/Paks/CATInterstellar-LinuxNoEditor.pak
4035  -  /home/mikhail/.local/share/Steam/steamapps/common/ShadowOfMordor/s=
hare/data/dlc2.arch05
4030  -  /home/mikhail/.local/share/Steam/steamapps/common/Call of
Duty WWII/imagefile123.pak
4020  -  /home/mikhail/.local/share/Steam/steamapps/common/Empire
Total War/data/models.pack
3694  -  /home/mikhail/.local/share/Steam/steamapps/common/Call of
Duty WWII/imagefile73.pak
3607  -  /home/mikhail/.local/share/Steam/steamapps/common/Motorcycle,
tricycle, ATV hill racing/mg_linux_Data/resources.assets.resS
3519  -  /home/mikhail/.local/share/Steam/steamapps/common/TheEvilWithin2/v=
irtualtextures/st03_main.pages
3483  -  /home/mikhail/.local/share/Steam/steamapps/common/NieRAutomata/dat=
a/data015.cpk
3470  -  /home/mikhail/.local/share/Steam/steamapps/common/Company of
Heroes 2/share/data/coh2/archives/artaefskins.sga
3416  -  /home/mikhail/.local/share/Steam/steamapps/common/ShadowOfMordor/s=
hare/data/son.arch05
3403  -  /home/mikhail/.local/share/Steam/steamapps/common/Hitman=E2=84=A2/=
share/data/runtime/dlc0.rpkg
3351  -  /home/mikhail/.local/share/Steam/steamapps/common/Deus Ex
Mankind Divided/share/data/dlc/runtime/dlcpreorder.layer.0.all.archive
3257  -  /home/mikhail/.local/share/Steam/steamapps/common/Company of
Heroes 2/share/data/coh2/archives/artsovietef.sga
3115  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/update/x64/dlcpacks/mpbattle/dlc.rpf
3019  -  /home/mikhail/.local/share/Steam/steamapps/common/Company of
Heroes 2/share/data/coh2/archives/artwestgerman.sga
3000  -  /home/mikhail/.local/share/Steam/steamapps/common/Dying
Light/DW/Data/common_textures_0_linux.rpack
2854  -  /home/mikhail/.local/share/Steam/steamapps/common/Call of
Duty WWII/imagefile169.pak
2759  -  /home/mikhail/.local/share/Steam/steamapps/common/The Evil
Within Demo/virtualtextures/common_vmtr.pages
2735  -  /home/mikhail/.local/share/Steam/steamapps/common/Broken
Sword 5/graphics_1080.vt7a
2676  -  /home/mikhail/.local/share/Steam/steamapps/common/NieRAutomata/dat=
a/data016.cpk
2590  -  /home/mikhail/.local/share/Steam/steamapps/common/Wildlands/DataPC=
_patch_01.forge
2588  -  /home/mikhail/.local/share/Steam/steamapps/common/AtomUniverse/Ato=
mUniverse/Content/Paks/AtomUniverse-WindowsNoEditor.pak
2548  -  /home/mikhail/.local/share/Steam/steamapps/common/Company of
Heroes 2/share/data/coh2/archives/artgermanef.sga
2516  -  /home/mikhail/.local/share/Steam/steamapps/common/Dying
Light/DW/Data/common_textures_1_linux.rpack
2488  -  /home/mikhail/.local/share/Steam/steamapps/common/Dying
Light/DW/Data/common_textures_2_linux.rpack
2439  -  /home/mikhail/.local/share/Steam/steamapps/common/Emily Wants
to Play Too/EWTP_Too/Content/Paks/EWTP_Too-LinuxNoEditor.pak
2409  -  /home/mikhail/.local/share/Steam/steamapps/common/ShadowOfMordor/s=
hare/data/udun_weather.arch05
2400  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64q.rpf
2398  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64/audio/sfx/INTERACTIVE_MUSIC.rpf
2396  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/update/x64/dlcpacks/mpheist/dlc.rpf
2295  -  /home/mikhail/.local/share/Steam/steamapps/common/RESIDENT
EVIL 7 biohazard Demo/re_chunk_000.pak
2239  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64l.rpf
2196  -  /home/mikhail/.local/share/Steam/steamapps/common/Saints Row
2/music4.vpp_pc
2178  -  /home/mikhail/.local/share/Steam/steamapps/common/Call of
Duty WWII/imagefile1.pak
2162  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64g.rpf
2145  -  /home/mikhail/.local/share/Steam/steamapps/common/Saints Row
the Third/packfiles/pc/cache/sr3_city_1.vpp_pc
2075  -  /home/mikhail/.local/share/Steam/steamapps/common/Motorcycle,
tricycle, ATV hill racing/mg_linux_Data/sharedassets3.assets
2052  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64k.rpf
2052  -  /home/mikhail/.cache/tracker/meta.db
2038  -  /home/mikhail/.local/share/Steam/steamapps/common/Mother
Russia Bleeds/Documentary Le Cartel 1080p.mp4
1931  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/update/x64/dlcpacks/patchday3ng/dlc.rpf
1924  -  /home/mikhail/.local/share/Steam/steamapps/common/ShadowOfMordor/s=
hare/data/son_weather.arch05
1895  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/update/x64/dlcpacks/mpchristmas2017/dlc.rpf
1893  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.009.tiger
1891  -  /home/mikhail/.local/share/Steam/steamapps/common/TEKKEN
7/TekkenGame/Content/Paks/pakchunk0-WindowsNoEditor_P.pak
1870  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.007.tiger
1867  -  /home/mikhail/.local/share/Steam/steamapps/common/Dead or
Alive 5 Last Round/chara_common.lnk
1836  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.update1.002.000.tiger
1827  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.008.tiger
1824  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.010.tiger
1823  -  /home/mikhail/Downloads/Silicon.Valley.S02.1080p.BluRay.x264/Silic=
on.Valley.S02E06.1080p.BluRay.x264.mkv
1817  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.006.tiger
1811  -  /home/mikhail/.local/share/Steam/steamapps/common/Rise of the
Tomb Raider/share/data/bigfile.005.tiger
1803  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64e.rpf
1785  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.004.tiger
1785  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64j.rpf
1766  -  /home/mikhail/.local/share/Steam/steamapps/common/Wildlands/DataPC=
_extra.forge
1762  -  /home/mikhail/.local/share/Steam/steamapps/common/Rise of the
Tomb Raider/share/data/bigfile.004.tiger
1753  -  /home/mikhail/.local/share/Steam/steamapps/common/Tomb
Raider/share/data/bigfile.002.tiger
1751  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.003.tiger
1751  -  /home/mikhail/.local/share/Steam/steamapps/common/Rise of the
Tomb Raider/share/data/bigfile.006.tiger
1750  -  /home/mikhail/.local/share/Steam/steamapps/common/Saints Row
IV/packfiles/pc/cache/sr3_city_0.vpp_pc
1746  -  /home/mikhail/.local/share/Steam/steamapps/common/Rise of the
Tomb Raider/share/data/bigfile.003.tiger
1742  -  /home/mikhail/.local/share/Steam/steamapps/common/Grand Theft
Auto V/x64c.rpf
1739  -  /home/mikhail/.local/share/Steam/steamapps/common/The Evil
Within Demo/virtualtextures/Remnants_vmtr.pages
1736  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.005.tiger
1721  -  /home/mikhail/.local/share/Steam/steamapps/common/Shadow of
the Tomb Raider/bigfile.002.tiger
1721  -  /home/mikhail/.local/share/Steam/steamapps/common/Atelier
Sophie The Alchemist of the Mysterious Book/PACK00.pak

The biggest concern is the presence file
"/home/mikhail/.cache/tracker/meta.db" in this list.
Because this is a base of indexed files in GNOME.

Also surprised that file
"/home/mikhail/.local/share/Steam/steamapps/common/Deus Ex Mankind
Divided/share/data/runtime/game.layer.0.all.archive" are divided on
20511 parts, although on the partition is enough free continuous space
for store this file as one indivisible part.

The purpose of my research was to show that despite the fact that with
average 1.75 extents per file, is possible find files on the disk
that, for some unknown reason, are divided on 20K parts.

--
Best Regards,
Mike Gavrilov.

--0000000000009d0ac40577cf24e8
Content-Type: application/octet-stream; name=top100_fragmented_files
Content-Disposition: attachment; filename=top100_fragmented_files
Content-Transfer-Encoding: base64
Content-ID: <f_jn205ifv0>
X-Attachment-Id: f_jn205ifv0

IyEvdXNyL2Jpbi9lbnYgYmFzaApkZWNsYXJlIC1nQSByZXN1bHQKZmluZCB+IC10eXBlIGYgfCAo
Cgl3aGlsZSByZWFkIC1yIGZpbGU7IGRvCgkJZWNobyAiUHJvY2Vzc2luZyBmaWxlOiAkZmlsZSIK
CQlvdXQ9JCh4ZnNfYm1hcCAiJGZpbGUiKQoJCWlmIFsgJD8gLWVxIDAgXTsgdGhlbgoJCQlyZXN1
bHRbJGZpbGVdPSQoKCQoZWNobyAiJG91dCIgfCB3YyAtbCkgLSAxKSkKCQlmaQoJZG9uZQoKCWVj
aG8gIlNvcnRpbmcgcmVzdWx0IC4uLiIKCWZvciBrIGluICIkeyFyZXN1bHRbQF19IgoJZG8KCSAg
ZWNobyAke3Jlc3VsdFsiJGsiXX0gJyAtICcgJGsKCWRvbmUgfCBzb3J0IC1yaCB8IGhlYWQgLTEw
MAopCg==
--0000000000009d0ac40577cf24e8--
