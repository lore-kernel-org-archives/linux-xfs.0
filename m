Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37395 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726333AbfBZPDY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Feb 2019 10:03:24 -0500
Subject: Re: Corruption of in-memory data detected. Shutting down filesystem
References: <b4141aed-70f1-83de-92e3-b8c9494900c7@molgen.mpg.de>
 <20190218142203.p53qvipc4yul6mv6@hades.usersys.redhat.com>
 <20190218143403.GB33924@bfoster>
 <0d3627ab-34e6-a800-c562-c25c578e3c6a@molgen.mpg.de>
 <20190218161746.GE33924@bfoster> <20190218173251.GF6503@magnolia>
 <20190218175722.GF33924@bfoster>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <e9f4af9a-7188-7913-8aef-41869179cbab@molgen.mpg.de>
Date: Tue, 26 Feb 2019 16:03:21 +0100
MIME-Version: 1.0
In-Reply-To: <20190218175722.GF33924@bfoster>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080605060007040506070301"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, it+linux-xfs@molgen.mpg.de

This is a cryptographically signed message in MIME format.

--------------ms080605060007040506070301
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Dear Brian, dear Darrick,


On 02/18/19 18:57, Brian Foster wrote:
> On Mon, Feb 18, 2019 at 09:32:51AM -0800, Darrick J. Wong wrote:
>> On Mon, Feb 18, 2019 at 11:17:46AM -0500, Brian Foster wrote:
>>> On Mon, Feb 18, 2019 at 04:08:00PM +0100, Paul Menzel wrote:

>>>> On 02/18/19 15:34, Brian Foster wrote:
>>>>> On Mon, Feb 18, 2019 at 03:22:03PM +0100, Carlos Maiolino wrote:
>>>>
>>>>>>> [   25.506600] XFS (sdd): Mounting V5 Filesystem
>>>>>>> [   25.629621] XFS (sdd): Starting recovery (logdev: internal)
>>>>>>> [   25.685100] NFSD: starting 90-second grace period (net f000009=
8)
>>>>>>> [   26.433828] XFS (sdd): xfs_do_force_shutdown(0x8) called from =
line 368 of file fs/xfs/xfs_trans.c.  Return address =3D 00000000cfa623e1=

>>>>>>> [   26.433834] XFS (sdd): Corruption of in-memory data detected. =
 Shutting down filesystem
>>>>>>> [   26.433835] XFS (sdd): Please umount the filesystem and rectif=
y the problem(s)
>>>>>>> [   26.433857] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() re=
turned error -5.
>>>>>>>
>>>>>> Ok, filesystem shut itself down likely because blocks allocated in=
 the
>>>>>> transaction exceeded the reservation.
>>>>
>>>>>>> We mounted it with an overlay files,
>>>>>>
>>>>>> I'm not sure what you meant here, could you please specify what yo=
u meant by
>>>>>> 'overlay files'? Are you using this XFS filesystem as an upper/low=
er FS for
>>>>>> overlayfs?
>>>>
>>>> To not touch the original data on `/dev/sdd` after the error we crea=
ted on overlay
>>>> FS to test xfs_repair, and analyze the effect.
>>>>
>>>> ```
>>>> # more /scratch/local3/mkoverlay.sh=20
>>>> dev=3D/dev/sdd
>>>> ovl=3D/scratch/local3/X4042-overlay.file
>>>> newdevname=3Dsddovl
>>>> size=3D$(blockdev --getsz "$dev")
>>>>
>>>> loop=3D$(losetup -f --show -- "$ovl")
>>>> printf '%s\n' "0 $size snapshot $dev $loop P 8"=20
>>>> printf '%s\n' "0 $size snapshot $dev $loop P 8" | dmsetup create "$n=
ewdevname"
>>>> # lsblk
>>>> NAME     MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>>>> loop0      7:0    0    10G  0 loop=20
>>>> loop1      7:1    0    10G  0 loop=20
>>>> =E2=94=94=E2=94=80sddovl 252:0    0    51T  0 dm  =20
>>>> sda        8:0    0 931.5G  0 disk=20
>>>> =E2=94=9C=E2=94=80sda1     8:1    0   256G  0 part /
>>>> =E2=94=94=E2=94=80sda2     8:2    0 675.5G  0 part /amd/tinytina/0
>>>> sdb        8:16   0 931.5G  0 disk /amd/tinytina/1
>>>> sdc        8:32   0  27.3T  0 disk /amd/tinytina/2
>>>> sdd        8:48   0    51T  0 disk=20
>>>> =E2=94=94=E2=94=80sddovl 252:0    0    51T  0 dm  =20
>>>> sde        8:64   0    51T  0 disk /amd/tinytina/X/X4075
>>>> sdf        8:80   0    51T  0 disk /amd/tinytina/X/X4076
>>>> ```
>>>>
>>>>>>> and the xfs_repair shows the summary below.
>>>>>>>
>>>>>>> ```
>>>>>>> # xfs_repair -vv /dev/mapper/sddovl
>>>>>>>         - block cache size set to 4201400 entries
>>>>>>> Phase 2 - using internal log
>>>>>>>         - zero log...
>>>>>>> zero_log: head block 3930112 tail block 3929088
>>>>>>> ERROR: The filesystem has valuable metadata changes in a log whic=
h needs to
>>>>>>> be replayed.  Mount the filesystem to replay the log, and unmount=
 it before
>>>>>>> re-running xfs_repair.  If you are unable to mount the filesystem=
, then use
>>>>>>> the -L option to destroy the log and attempt a repair.
>>>>>>> Note that destroying the log may cause corruption -- please attem=
pt a mount
>>>>>>
>>>>>> Have you tried to mount/umount the filesystem before zeroing the l=
og? This is
>>>>>> supposed to be used as a last resort. Zero out the logs I mean.
>>>>
>>>> Yes, we tried that, and were told to run `xfs_repair`.
>>>>
>>>>>>> The directory `lost+found` contains almost five million files
>>>>>>>
>>>>>>>     # find lost+found | wc
>>>>>>>     4859687 4859687 110985720
>>>>>>
>>>>>> We don't have neither the whole xfs_repair output nor more informa=
tion about the
>>>>>> filesystem itself, but looks like you had huge directory(ies) upda=
te in your log
>>>>>> which were not replayed, and all orphan inodes ended up in the los=
t+found =3D/
>>>>
>>>> I=E2=80=99ll see if I can share the 500 MB xfs_repair output.
>>>>
>>>> ```
>>>> $ lsblk /dev/sdd
>>>> NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
>>>> sdd    8:48   0  51T  0 disk
>>>> $ sudo xfs_info /dev/sdd
>>>> Password (for pmenzel) :=20
>>>> meta-data=3D/dev/sdd               isize=3D512    agcount=3D51, agsi=
ze=3D268435392 blks
>>>>          =3D                       sectsz=3D512   attr=3D2, projid32=
bit=3D1
>>>>          =3D                       crc=3D1        finobt=3D1, sparse=
=3D0, rmapbt=3D0
>>>>          =3D                       reflink=3D0
>>>> data     =3D                       bsize=3D4096   blocks=3D136718382=
08, imaxpct=3D1
>>>>          =3D                       sunit=3D64     swidth=3D896 blks
>>>> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftyp=
e=3D1
>>>> log      =3Dinternal log           bsize=3D4096   blocks=3D521728, v=
ersion=3D2
>>>>          =3D                       sectsz=3D512   sunit=3D64 blks, l=
azy-count=3D1
>>>> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexte=
nts=3D0
>>>> ```
>>>>
>>>>>>> We saved the output of `xfs_repair`, but it=E2=80=99s over 500 MB=
 in size, so we
>>>>>>> cannot attach it.
>>>>>>>
>>>>>>> `sudo xfs_metadump -go /dev/sdd sdd-metadump.dump` takes over 15 =
minutes
>>>>>>> and the dump files is 8.8 GB in size.
>>>>>>
>>>>>> At this point, xfs_metadump won't help much once you already repai=
red the
>>>>>> filesystem.
>>>>
>>>> As written, we only run the repair on the overlay.
>>>>
>>>>>> Although, why are you getting a metadump from /dev/sdd, when the f=
s you tried to
>>>>>> repair is a device-mapper device? Are you facing this issue in mor=
e than one
>>>>>> filesystem?
>>>>
>>>> As written above, it was to not touch `/dev/sdd`. So the meta data d=
ump should be
>>>> useable.
>>>>
>>>>>>> It=E2=80=99d be great, if you could give hints on debugging this =
issue further,
>>>>>>> and comment, if you think it is possible to recover the files, th=
at means,
>>>>>>> to fix the log, so that it can be cleanly applied.
>>>>>>
>>>>>> Unfortunately, you already got rid of the log, so, you can't recov=
er it anymore,
>>>>>> but all the recovered files will be in lost+found, with their inod=
e numbers as
>>>>>> file name.
>>>>>>
>>>>>> Ok, so below is the dmesg, thanks for having attached it.
>>>>>>
>>>>>> One thing is there are 2 devices failing. sdd and dm-0. So my ques=
tion again, is
>>>>>> this the same filesystem or are they 2 separated filesystems showi=
ng exactly the
>>>>>> same issue? The filesystem has found corrupted inodes in the AG's =
unlinked
>>>>>> bucket, but this shouldn't affect log recovery.
>>>>>>
>>>>>> If they are two separated devices, did you xfs_repair'ed both of t=
hem? After you
>>>>>> repaired the filesystem(s), do you still see the memory corruption=
 issue?
>>>>
>>>> No, we do not see the corruption issue anymore, and mounting works a=
s expected.
>>>>
>>>>>> At this point, there is not much we can do regarding the filesyste=
m metadata,
>>>>>> once you already forced a xfs_repair zeroing the logs.
>>>>>>
>>>>>> So, could you please tell the current state of the filesystem (or =
filesystems if
>>>>>> there is more than one)? Are you still seeing the same memory corr=
uption error
>>>>>> even after xfs_repair it?
>>>>
>>>> The user wants to continue using the device, and does not need the r=
ecovered files,
>>>> so we had to go ahead, and repair `/dev/sde` now too. We are only in=
terested in
>>>> having this bug fixed in XFS, and not about data recovery.
>>>>
>>>
>>> Well, if the metadump is still available and is based on the original=

>>> (broken) fs then it may be able to reproduce the original problem. Ho=
w
>>> large is it compressed? Would you be able to upload it somewhere?
>>>
>>> Brian
>>>
>>>>> FWIW, if you do still have an original copy of the fs, we could see=

>>>>> about whether bypassing the shutdown allows us to trade log recover=
y
>>>>> failure for a space accounting error. This would still require a
>>>>> subsequent repair, but that may be less invasive than zapping the l=
og
>>>>> and dealing with the aftermath of that.
>>>>
>>>> Unfortunately, it=E2=80=99s 50 TB, so we do not have a copy anymore.=

>>>>
>>>>>> And for completeness, please provide us as much information as pos=
sible from
>>>>>> this(these) filesystem(s):
>>>>>>
>>>>>> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_incl=
ude_when_reporting_a_problem.3F
>>>>
>>>>     /dev/sdd /amd/tinytina/X/X4074 xfs rw,relatime,attr2,inode64,log=
bsize=3D256k,sunit=3D512,swidth=3D7168,noquota 0 0
>>>>
>>>>>>> [ 1380.869451] XFS (sdd): Mounting V5 Filesystem
>>>>>>> [ 1380.912559] XFS (sdd): Starting recovery (logdev: internal)
>>>>>>> [ 1381.030780] XFS (sdd): xfs_do_force_shutdown(0x8) called from =
line 368 of file fs/xfs/xfs_trans.c.  Return address =3D 00000000cfa623e1=

>>
>> <groan> Funny, I saw this exact same thing a week ago.  We really ough=
t
>> to record a stack trace when we cancel dirty transactions.
>>
>> Hmm, so leaking millions of nfs file handles ... were they temporary o=
r
>> deleted files?
>>
>> I bet I know exactly what caused this -- freeing unlinked inodes that
>> required a free inode btree expansion, but m_inotbt_nores was
>> incorrectly set during log recovery so we didn't reserve any blocks an=
d
>> blew up.
>=20
> Interesting. I suppose rather than upload it, the user could try to
> restore the metadump somewhere, bump /proc/sys/fs/xfs/error_level to >=3D=
5
> and reproduce the mount failure to try and generate a stack trace.

Please find the 2.1 GB LZ4-compressed metadata dump at [1]. Please delete=

it after you are done using it for analysis.

>> Relevant patches that might fix this:
>>
>> "xfs: rename m_inotbt_nores to m_finobt_nores"
>> "xfs: reserve blocks for ifree transaction during log recovery"
>>
>> (As mentioned earlier, there's not much we can do once the log has bee=
n
>> zereod.)
>>
>> --D
>>
>>>>>>> [ 1381.030785] XFS (sdd): Corruption of in-memory data detected. =
 Shutting down filesystem
>>>>>>> [ 1381.030786] XFS (sdd): Please umount the filesystem and rectif=
y the problem(s)
>>>>>>> [ 1381.031086] XFS (sdd): xlog_recover_clear_agi_bucket: failed t=
o clear agi 0. Continuing.
>>>>>>> [ 1381.031088] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() re=
turned error -5.
>>>>>>> [ 1381.031090] XFS (sdd): xlog_recover_clear_agi_bucket: failed t=
o clear agi 0. Continuing.
>>>>>>> [ 1381.031093] XFS (sdd): xfs_imap_to_bp: xfs_trans_read_buf() re=
turned error -5.
>>>>>>> [ 1381.031095] XFS (sdd): xlog_recover_clear_agi_bucket: failed t=
o clear agi 0. Continuing.
>>>>>> <...>
>>>>>>> [ 1381.031113] XFS (sdd): Ending recovery (logdev: internal)
>>>>>>> [ 1381.031490] XFS (sdd): Error -5 reserving per-AG metadata rese=
rve pool.
>>>>>>> [ 1381.031492] XFS (sdd): xfs_do_force_shutdown(0x8) called from =
line 548 of file fs/xfs/xfs_fsops.c.  Return address =3D 00000000217dbba5=

>>>>>>
>>>>>>> [ 2795.123228] XFS (dm-0): Ending recovery (logdev: internal)
>>>>>>> [ 2795.231020] XFS (dm-0): Error -5 reserving per-AG metadata res=
erve pool.
>>>>>>> [ 2795.231023] XFS (dm-0): xfs_do_force_shutdown(0x8) called from=
 line 548 of file fs/xfs/xfs_fsops.c.  Return address =3D 00000000217dbba=
5
>>>>>>
>>>>>>> [10944.023429] XFS (dm-0): Mounting V5 Filesystem
>>>>>>> [10944.035260] XFS (dm-0): Ending clean mount
>>>>>>> [11664.862376] XFS (dm-0): Unmounting Filesystem
>>>>>>> [11689.260213] XFS (dm-0): Mounting V5 Filesystem
>>>>>>> [11689.338187] XFS (dm-0): Ending clean mount
>>>>
>>>> As written, data recovery is not needed anymore, but, if it=E2=80=99=
d help the driver,
>>>> we could share the logs we have (after making sure it=E2=80=99s obfu=
scated).
>>>>
>>>> Please tell us, if you are interested, and what dumps, xfs_repair ou=
tput and
>>>> so on would be needed.

Kind regards,

Paul


[1]: https://www.molgen.mpg.de/~pmenzel/sdd-metadump.dump.lz4


--------------ms080605060007040506070301
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
EFowggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWNMIIEdaADAgECAgwcOtRQhH7u81j4jncwDQYJKoZIhvcNAQELBQAwgZUx
CzAJBgNVBAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1
dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNV
BAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjAeFw0xNjExMDMxNTI0
NDhaFw0zMTAyMjIyMzU5NTlaMGoxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCYXllcm4xETAP
BgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxhbmNrLUdlc2VsbHNjaGFmdDEVMBMG
A1UEAwwMTVBHIENBIC0gRzAyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnhx4
59Lh4WqgOs/Md04XxU2yFtfM15ZuJV0PZP7BmqSJKLLPyqmOrADfNdJ5PIGBto2JBhtRRBHd
G0GROOvTRHjzOga95WOTeura79T21FWwwAwa29OFnD3ZplQs6HgdwQrZWNi1WHNJxn/4mA19
rNEBUc5urSIpZPvZi5XmlF3v3JHOlx3KWV7mUteB4pwEEfGTg4npPAJbp2o7arxQdoIq+Pu2
OsvqhD7Rk4QeaX+EM1QS4lqd1otW4hE70h/ODPy1xffgbZiuotWQLC6nIwa65Qv6byqlIX0q
Zuu99Vsu+r3sWYsL5SBkgecNI7fMJ5tfHrjoxfrKl/ErTAt8GQIDAQABo4ICBTCCAgEwEgYD
VR0TAQH/BAgwBgEB/wIBATAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0gBCIwIDANBgsrBgEEAYGt
IYIsHjAPBg0rBgEEAYGtIYIsAQEEMB0GA1UdDgQWBBTEiKUH7rh7qgwTv9opdGNSG0lwFjAf
BgNVHSMEGDAWgBST49gyJtrV8UqlkUrg6kviogzP4TCBjwYDVR0fBIGHMIGEMECgPqA8hjpo
dHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jcmwvY2Fjcmwu
Y3JsMECgPqA8hjpodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1
Yi9jcmwvY2FjcmwuY3JsMIHdBggrBgEFBQcBAQSB0DCBzTAzBggrBgEFBQcwAYYnaHR0cDov
L29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEoGCCsGAQUFBzAChj5odHRwOi8v
Y2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNy
dDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1j
YS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBABLpeD5FygzqOjj+
/lAOy20UQOGWlx0RMuPcI4nuyFT8SGmK9lD7QCg/HoaJlfU/r78ex+SEide326evlFAoJXIF
jVyzNltDhpMKrPIDuh2N12zyn1EtagqPL6hu4pVRzcBpl/F2HCvtmMx5K4WN1L1fmHWLcSap
dhXLvAZ9RG/B3rqyULLSNN8xHXYXpmtvG0VGJAndZ+lj+BH7uvd3nHWnXEHC2q7iQlDUqg0a
wIqWJgdLlx1Q8Dg/sodv0m+LN0kOzGvVDRCmowBdWGhhusD+duKV66pBl+qhC+4LipariWaM
qK5ppMQROATjYeNRvwI+nDcEXr2vDaKmdbxgDVwwggWvMIIEl6ADAgECAgweKlJIhfynPMVG
/KIwDQYJKoZIhvcNAQELBQAwajELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8G
A1UEBwwITXVlbmNoZW4xIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MRUwEwYD
VQQDDAxNUEcgQ0EgLSBHMDIwHhcNMTcxMTE0MTEzNDE2WhcNMjAxMTEzMTEzNDE2WjCBizEL
MAkGA1UEBhMCREUxIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MTQwMgYDVQQL
DCtNYXgtUGxhbmNrLUluc3RpdHV0IGZ1ZXIgbW9sZWt1bGFyZSBHZW5ldGlrMQ4wDAYDVQQL
DAVNUElNRzEUMBIGA1UEAwwLUGF1bCBNZW56ZWwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDIh/UR/AX/YQ48VWWDMLTYtXjYJyhRHMc81ZHMMoaoG66lWB9MtKRTnB5lovLZ
enTIUyPsCrMhTqV9CWzDf6v9gOTWVxHEYqrUwK5H1gx4XoK81nfV8oGV4EKuVmmikTXiztGz
peyDmOY8o/EFNWP7YuRkY/lPQJQBeBHYq9AYIgX4StuXu83nusq4MDydygVOeZC15ts0tv3/
6WmibmZd1OZRqxDOkoBbY3Djx6lERohs3IKS6RKiI7e90rCSy9rtidJBOvaQS9wvtOSKPx0a
+2pAgJEVzZFjOAfBcXydXtqXhcpOi2VCyl+7+LnnTz016JJLsCBuWEcB3kP9nJYNAgMBAAGj
ggIxMIICLTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwHQYDVR0OBBYEFHM0Mc3XjMLlhWpp4JufRELL4A/qMB8GA1UdIwQYMBaA
FMSIpQfuuHuqDBO/2il0Y1IbSXAWMCAGA1UdEQQZMBeBFXBtZW56ZWxAbW9sZ2VuLm1wZy5k
ZTB9BgNVHR8EdjB0MDigNqA0hjJodHRwOi8vY2RwMS5wY2EuZGZuLmRlL21wZy1nMi1jYS9w
dWIvY3JsL2NhY3JsLmNybDA4oDagNIYyaHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzIt
Y2EvcHViL2NybC9jYWNybC5jcmwwgc0GCCsGAQUFBwEBBIHAMIG9MDMGCCsGAQUFBzABhido
dHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwQgYIKwYBBQUHMAKGNmh0
dHA6Ly9jZHAxLnBjYS5kZm4uZGUvbXBnLWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBC
BggrBgEFBQcwAoY2aHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzItY2EvcHViL2NhY2Vy
dC9jYWNlcnQuY3J0MEAGA1UdIAQ5MDcwDwYNKwYBBAGBrSGCLAEBBDARBg8rBgEEAYGtIYIs
AQEEAwYwEQYPKwYBBAGBrSGCLAIBBAMGMA0GCSqGSIb3DQEBCwUAA4IBAQCQs6bUDROpFO2F
Qz2FMgrdb39VEo8P3DhmpqkaIMC5ZurGbbAL/tAR6lpe4af682nEOJ7VW86ilsIJgm1j0ueY
aOuL8jrN4X7IF/8KdZnnNnImW3QVni6TCcc+7+ggci9JHtt0IDCj5vPJBpP/dKXLCN4M+exl
GXYpfHgxh8gclJPY1rquhQrihCzHfKB01w9h9tWZDVMtSoy9EUJFhCXw7mYUsvBeJwZesN2B
fndPkrXx6XWDdU3S1LyKgHlLIFtarLFm2Hb5zAUR33h+26cN6ohcGqGEEzgIG8tXS8gztEaj
1s2RyzmKd4SXTkKR3GhkZNVWy+gM68J7jP6zzN+cMYIDmjCCA5YCAQEwejBqMQswCQYDVQQG
EwJERTEPMA0GA1UECAwGQmF5ZXJuMREwDwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4
LVBsYW5jay1HZXNlbGxzY2hhZnQxFTATBgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzF
RvyiMA0GCWCGSAFlAwQCAQUAoIIB8TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xOTAyMjYxNTAzMjFaMC8GCSqGSIb3DQEJBDEiBCAo/yvbdWknLt0Nq76c
ANorpaho9EDNd9abm1flJ2GOsjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGJBgkrBgEEAYI3EAQxfDB6MGoxCzAJBgNVBAYTAkRF
MQ8wDQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxh
bmNrLUdlc2VsbHNjaGFmdDEVMBMGA1UEAwwMTVBHIENBIC0gRzAyAgweKlJIhfynPMVG/KIw
gYsGCyqGSIb3DQEJEAILMXygejBqMQswCQYDVQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREw
DwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4LVBsYW5jay1HZXNlbGxzY2hhZnQxFTAT
BgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzFRvyiMA0GCSqGSIb3DQEBAQUABIIBACwK
jepWtRQpDiJXUcua7ppeslyf/nNNCWgTRVKTMWUw+Mz1FIA8zXxTspOeywjhZZVm6qrp7unn
vq0WmInC5TQH0aJUJJ760CSRfimpifQhV2X935yOxxLsUokR8pbvLXOM0qpwRneKeJMtly7v
Qwhg3aRZAp2i6ugr8yZSXNa/THTgFQqojuDbBPg3l3tmJ1pPpClknBVDL0AZQvHZsA5j0oNC
EfYs+TA86cbZupo8g9zDaUWkQKNsT0vbK171e8fuMpvn9zx8D3pXMsvOe5jzlub6/TU/dIxZ
IEOQ84hejP1PiBo9xZ/VVFdtjYB+S7FvhN2YGI6eImIuH2zaRRUAAAAAAAA=
--------------ms080605060007040506070301--
