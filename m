Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA7397CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 08:52:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4526FAC006
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 06:52:02 -0700 (PDT)
Received: from mx.recia.fr (mx.recia.fr [95.128.41.47]) by cuda.sgi.com with
	ESMTP id KkxvRfmxDAccTXLE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 06:51:59 -0700 (PDT)
Subject: Re: Bug (?) : cumulative xfsrestore does not restore files and
	folders in a directory which was renamed
References: <a08ae222-7654-4a6f-d9ba-f70017784f74@recia.fr>
	<20160622220959.GV12670@dastard> <20160622222328.GW12670@dastard>
	<20160623014217.GZ12670@dastard>
From: Damien Gombault <damien.gombault@recia.fr>
Message-ID: <eacabe85-cdff-7fbc-8bb6-c8eb51fc0dac@recia.fr>
Date: Fri, 24 Jun 2016 15:51:57 +0200
MIME-Version: 1.0
In-Reply-To: <20160623014217.GZ12670@dastard>
Content-Type: multipart/mixed; boundary="------------02BA962CC061415C1E234270"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------02BA962CC061415C1E234270
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi.

Thank you for the patch.

The patch fixes simple cases (like my reproducer) but it does not fix
restoration of more complex directory structures : I have tested the 
patch on my
real data, it fixes some but not all warnings (a user renamed/moved a 
lots of
files and directory between the 2 dumps).

Here is another testcase which fails (with the patch) :

mkdir dira
mkdir dira/dirc
touch dira/dirc/filea
mkdir dirb

.
├── dira
│   └── dirc
│       └── filea
└── dirb

Make a level 0 dump.

mv dirb dira/dirB
mv dira/dirc/ dira/dirB/dirC
touch dira/dirB/dirC/fileb

.
└── dira
     └── dirB
         └── dirC
             ├── filea
             └── fileb

Make a level 1 dump.

Restore level 0 then level 1 dump, you will get :

xfsrestore: directory post-processing
xfsrestore: WARNING: unable to set secure extended attribute for 
dira/dirB: No
such file or directory (2)
xfsrestore: restoring non-directory files
xfsrestore: WARNING: open of dira/dirB/dirC/fileb failed: No such file or
directory: discarding ino 524386
xfsrestore: WARNING: unable to set secure extended attribute for
dira/dirB/dirC/fileb: No such file or directory (2)
xfsrestore: WARNING: path_to_handle of dira/dirB/dirC failed:No such file or
directory
xfsrestore: could not set access and modification times of 
dira/dirB/dirC: No
such file or directory
xfsrestore: chown (uid=0, gid=0) dira/dirB/dirC failed: No such file or
directory
xfsrestore: chmod dira/dirB/dirC failed: No such file or directory
xfsrestore: WARNING: attempt to set extended attributes (xflags 0x80000000,
extsize = 0x0, projid = 0x0) of dira/dirB/dirC failed: Bad file descriptor
xfsrestore: WARNING: path_to_handle of dira/dirB failed:No such file or
directory
xfsrestore: could not set access and modification times of dira/dirB: No 
such
file or directory
xfsrestore: chown (uid=0, gid=0) dira/dirB failed: No such file or directory
xfsrestore: chmod dira/dirB failed: No such file or directory
xfsrestore: WARNING: attempt to set extended attributes (xflags 0x80000000,
extsize = 0x0, projid = 0x0) of dira/dirB failed: Bad file descriptor
xfsrestore: WARNING: unable to rmdir /mnt/test//orphanage: Directory not 
empty

Directory dirB is placed in orphanage folder and fileb is not restored :

.
├── dira
├── orphanage
│   └── 1069152.734839917
│       └── dirC
│           └── filea
└── xfsrestorehousekeepingdir
     ├── dirattr
     ├── dirextattr
     ├── namreg
     ├── state
     └── tree

--
Damien Gombault

Le 23/06/2016 à 03:42, Dave Chinner a écrit :
> On Thu, Jun 23, 2016 at 08:23:28AM +1000, Dave Chinner wrote:
>> On Thu, Jun 23, 2016 at 08:09:59AM +1000, Dave Chinner wrote:
>>> But it seems that dirb hasn't been created before the file in it
>>> is being restored. THis can happen because the inventory is not
>>> correct, whichmay in fact be a problem with dump rather than
>>> restore...
>>>
>>> I'll have a bit of a play around here, see if I can reproduce it.
>> Yes, i can reproduce it, so I'll have a deeper look.
> Can you try this patch?
>
> -Dave


--------------02BA962CC061415C1E234270
Content-Type: text/x-vcard; charset=utf-8;
 name="damien_gombault.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="damien_gombault.vcf"

begin:vcard
fn:Damien Gombault
n:Gombault;Damien
org;quoted-printable:GIP Recia =E2=88=92 Centre de ressources r=C3=A9gional du num=C3=A9rique
adr;quoted-printable;dom:Parc d'Activit=C3=A9s les Aulnaies;;151, Rue de la Juine;Olivet;;45160
email;internet:damien.gombault@recia.fr
title;quoted-printable:Responsable des syst=C3=A8mes informatiques
tel;work:02 38 42 14 71
tel;cell:06 42 62 78 19
url:http://recia.fr
version:2.1
end:vcard


--------------02BA962CC061415C1E234270
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------02BA962CC061415C1E234270--
