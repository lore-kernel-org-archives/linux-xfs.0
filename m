Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:37505 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753239AbdGSVIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 17:08:43 -0400
Received: by mail-io0-f196.google.com with SMTP id 5so727990iow.4
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2017 14:08:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net>
References: <F180D8D4-633B-4CC5-8D70-5CAC36233513@cs.cmu.edu>
 <CAAxjCEzevLnmxyVRME1-kT867KjH2rtOdspv7nF6TOfLUDD+xA@mail.gmail.com>
 <20170717234814.GK17762@dastard> <CAAxjCEzP=bf5S12J8rTn7EyJK_MeM=t1JSa7pBzZyXK=9TrjQQ@mail.gmail.com>
 <bcb651de-75bf-97a6-7ed8-c083d2a440e5@sandeen.net>
From: Stefan Ring <stefanrin@gmail.com>
Date: Wed, 19 Jul 2017 23:08:41 +0200
Message-ID: <CAAxjCEzZ2Q0wL=nhGVHVtK3M5Ws3MQdrUNKm3jJKO+1y-wxTkw@mail.gmail.com>
Subject: Re: Collecting aged XFS profiles
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Wed, Jul 19, 2017 at 5:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 07/19/2017 02:59 AM, Stefan Ring wrote:
>> I have created a metadump that is 1GB in size, xz-compressed. However,
>> by running strings on it I find that there are many identifiable
>> remains inside, and I cannot legally pass this on.
>
> newer metadump should correct that problem, and is a read-only tool,
> so should be (tm) perfectly safe (tm).  You could run it out of a built
> git repo, via the xfs_db commands.
>
>> The question is: can I import this metadata image in a VM and recreate
>> the metadata image from there, using modern xfsprogs? Will this
>> preserve most of the relevant information?
>
> yes, that would work too. (mdrestore followed by or piped through metadump)
> If you find significant strings in that result please let me know :)

There is still quite a lot of stuff that should not be there (pasted
selectively while scrolling over it via less):

File names:
10-stdio
6-log-shell_2-stdio.bz2
8-log-shell_4-stdio
:(%40-log-MasterShellCommand_1-stdio.bz2
2-log-hg_periotheus-stdio.bz2
:(#37-log-MasterShellCommand-stdio.bz2
42-log-systemcfg-1-stdio
2060
0:&'1937-log-MasterShellCommand_1-stdio.bz2
42-log-systemcfg-2-stdio
38-log-hg_periotheus-stdio.bz2
40-log-shell_7-stdio
1-log-shell_3-bootstrap.log.bz2
2-log-shell_3-bootstrap.log.bz2
38-log-shell_2-stdio.bz2
41-log-shell-stdio
_9-stdio.bz2
4-log-shell-stdio
38-log-shell_3-stdio.bz2
bootstrap.log.bz2
5-stdio
R       Um
43-log-shell_5-stdio
38-log-shell_6-test.log
43-log-systemcfg-1-stdio
38-log-shell_7-stdio
6-stdio.bz2
41-log-shell_1-stdio
2-log-shell_1-stdio
3-stdio
38-log-shell_8-stdio.bz2
43-log-systemcfg-2-stdio
38-log-shell_9-stdio.bz2

Random contents:
# This file is also read by man in order to find how to call nroff, less, etc.,
# and to determine the correspondence between extensions and decompressors.
# MANBIN                /usr/local/bin/man
# Every automatically generated MANPATH includes these fields
MANPATH /usr/man
MANPATH /usr/share/man
MANPATH /usr/local/man
MANPATH /usr/local/share/man
MANPATH /usr/X11R6/man
# Uncomment if you want to include one of these by default
# MANPATH       /opt/*/man
# MANPATH       /usr/lib/*/man
# MANPATH       /usr/share/*/man
# MANPATH       /usr/kerberos/man
# Set up PATH to MANPATH mapping
# If people ask for "man foo" and have "/dir/bin/foo" in their PATH
# and the docs are found in "/dir/man", then no mapping is required.
# The below mappings are superfluous when the right hand side is
# in the mandatory manpath already, but will keep man from statting
# lots of other nearby files and directories.
MANPATH_MAP     /bin                    /usr/share/man
MANPATH_MAP     /sbin                   /usr/share/man
MANPATH_MAP     /usr/bin                /usr/share/man
MANPATH_MAP     /usr/sbin               /usr/share/man
MANPATH_MAP     /usr/local/bin          /usr/local/share/man
MANPATH_MAP     /usr/local/sbin         /usr/local/share/man
MANPATH_MAP     /usr/X11R6/bin          /usr/X11R6/man
MANPATH_MAP     /usr/bin/X11            /usr/X11R6/man
MANPATH_MAP     /usr/bin/mh             /usr/share/man
# NOAUTOPATH keeps man from automatically adding directories that look like
# manual page directories to the path.
#NOAUTOPATH

Some stray file names in the middle of nowhere:
0pAB
0Lm_vrm
0VRgkg4YiYJ4
y       ?
Jm#\
Ym_v8j
Pstructure.yaml
i-EPEL
pRPM-GPG-KEY-beta
V`:h
Y[uG$P
_;bA
YmP|
@dataKN
PV3SspqG
Y%GE
$Y%GE
01.66TI
u8U7
.bau
+_weakrefset.pychangeset_and_sha256sums.sh
jni_create_stap.c
jni_desc
update_tarballs.sh
pEtWuoffV_SJ57dR3dTyogT44qdBy-BGDu
xdxX8Qs
e+X>
10dTGV  S.

Log files:
2015-04-15 16:25:34 (140466167215872)   File
"/opt/vtse/lib/python2.7/tempfile.py", line 300, in mkstemp
2015-04-15 16:25:34 (140466167215872)     return _mkstemp_inner(dir,
prefix, suffix, flags)
2015-04-15 16:25:34 (140466167215872)   File
"/opt/vtse/lib/python2.7/tempfile.py", line 235, in _mkstemp_inner
2015-04-15 16:25:34 (140466167215872)     fd = _os.open(file, flags, 0600)
2015-04-15 16:25:34 (140466167215872) OSError: [Errno 2] No such file
or directory:

Some SVG:
w3" y2="101.5" stroke="#000000" stroke-width="2.0" />
    <line x1="184.8" y1="105.0" x2="195.3" y2="108.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="210.0" y1="105.0" x2="199.5" y2="108.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="210.0" y1="105.0" x2="199.5" y2="101.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="184.8" y1="105.0" x2="210.0" y2="105.0" stroke="#000000"
stroke-width="2.0" />
</g>
<line x1="197.4" y1="112.0" x2="197.4" y2="133.0" stroke="#000000"
stroke-width="2.0" />
<line x1="4.2" y1="133.0" x2="197.4" y2="133.0" stroke="#000000"
stroke-width="2.0" />
<line x1="197.4" y1="133.0" x2="617.4" y2="133.0" stroke="#000000"
stroke-width="2.0" />
<line x1="4.2" y1="133.0" x2="4.2" y2="189.0" stroke="#000000"
stroke-width="2.0" />
<line x1="197.4" y1="133.0" x2="197.4" y2="154.0" stroke="#000000"
stroke-width="2.0" />
<line x1="449.4" y1="147.0" x2="600.6" y2="147.0" stroke="#000000"
stroke-width="2.0" />
<line x1="617.4" y1="133.0" x2="617.4" y2="189.0" stroke="#000000"
stroke-width="2.0" />
    <line x1="184.8" y1="161.0" x2="195.3" y2="157.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="184.8" y1="161.0" x2="195.3" y2="164.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="210.0" y1="161.0" x2="199.5" y2="164.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="210.0" y1="161.0" x2="199.5" y2="157.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="184.8" y1="161.0" x2="210.0" y2="161.0" stroke="#000000"
stroke-width="2.0" />
</g>
    <line x1="445.2" y1="161.0" x2="434.7" y2="164.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="445.2" y1="161.0" x2="434.7" y2="157.5" stroke="#000000"
stroke-width="2.0" />
    <line x1="428.4" y1="161.0" x2="445.2" y2="161.0" stroke="#000000"
stroke-width="4.0" />
</g>
<line x1="449.4" y1="147.0" x2="449.4" y2="175.0" stroke="#000000"
stroke-width="2.0" />
<line x1="600.6" y1="147.0" x2="600.6" y2="175.0" stroke="#000000"
stroke-width="2.0" />
<line x1="197.4" y1="168.0" x2="197.4" y2="189.0" stroke="#000000"
stroke-width="2.0" />

I used the current git version like this:
./db/xfs_db -f -i -p xfs_metadump -c "metadump -e -g -w -"
xfs-meta.rawimg | strings

commit e116c5c4511bbc2d98579817232258d57a1f1777
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri May 5 13:25:49 2017 -0500
