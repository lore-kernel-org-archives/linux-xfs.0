Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 18:50:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3M1o3rI017132
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 18:50:07 -0700
Message-Id: <200804220150.m3M1oZOl025124@mail125c25.carrierzone.com>
From: "Vincent Roy" <vincentr@geoglobal.com>
References: <200804211452.01772.support@geoglobal.com> <20080421223114.GS108924158@sgi.com>
Subject: RE: Fwd: xfs_repair -n report
Date: Mon, 21 Apr 2008 19:52:47 -0600
Message-ID: <003701c8a41b$91b416b0$2f0a0a0a@geoglobal.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0038_01C8A3E9.4719A6B0"
In-Reply-To: <20080421223114.GS108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'David Chinner' <dgc@sgi.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_0038_01C8A3E9.4719A6B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

That isn't good news. What do you suggest I do before totally trashing it,
what xfs_repair arguments should I at least try? The data volume size is as
it was before the RAID failure so the files are likely there and the RAID is
stable. I will try an xfsdump prior.
Regards,
Vincent

-----Original Message-----
From: David Chinner [mailto:dgc@sgi.com] 
Sent: Monday, April 21, 2008 4:31 PM
To: support@geoglobal.com
Cc: xfs@oss.sgi.com; vincent.roy@geoglobal.com
Subject: Re: Fwd: xfs_repair -n report

On Mon, Apr 21, 2008 at 02:52:01PM -0600, support@geoglobal.com wrote:
> Sorry, I truncated the original logfile of 128MB to a short version for 
> review. Again, all comments welcome.

Firstly, please post plain text attachments - that will cut down the
size of them as well...

> 
> Subject: xfs_repair -n report
> Date: Saturday 19 April 2008 23:22
> From: support@geoglobal.com
> To: xfs@oss.sgi.com, vincent.roy@geoglobal.com
> 
> RAID 5 - 4 disks on 9550 AMCC production machine / backup disk failed also
> verified without error - rebuilt after abrupt power shut down
> cannot mount - inconsistencies indicated - could not dump fs

Secondly, your raid has completely screwed the filesystem. I would
strongly suggest that you confirm that the rebuild of the RAID put
stuff back together properly (check things like the order of disks
in the stripe, etc). If it claims nothing is wrong, then it has been
lying to you.

I hope you have backups, because that's the only way you're going
to recover this mess.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

------=_NextPart_000_0038_01C8A3E9.4719A6B0
Content-Type: application/msword;
	name="testfile_raid.rtf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="testfile_raid.rtf"

{\rtf1\ansi\deff0\adeflang1025
{\fonttbl{\f0\froman\fprq2\fcharset0 Thorndale AMT{\*\falt Times New =
Roman};}{\f1\froman\fprq2\fcharset0 Thorndale AMT{\*\falt Times New =
Roman};}{\f2\fswiss\fprq2\fcharset0 Albany AMT{\*\falt =
Arial};}{\f3\fmodern\fprq1\fcharset0 Cumberland AMT{\*\falt Courier =
New};}{\f4\fnil\fprq2\fcharset0 Albany AMT{\*\falt =
Arial};}{\f5\fnil\fprq2\fcharset0 Lucidasans;}{\f6\fnil\fprq0\fcharset0 =
Lucidasans;}}
{\colortbl;\red0\green0\blue0;\red128\green128\blue128;}
{\stylesheet{\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\=
afs24\lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24=
\lang2057\snext1 Normal;}
{\s2\sb240\sa120\keepn\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlc=
h\afs28\lang255\ltrch\dbch\langfe255\hich\f2\fs28\lang2057\loch\f2\fs28\l=
ang2057\sbasedon1\snext3 Heading;}
{\s3\sa120\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057\sbasedon1\snext3 Body Text;}
{\s4\sa120\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af6\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057\sbasedon3\snext4 List;}
{\s5\sb120\sa120\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af6\=
afs24\lang255\ai\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\i\loch\f0=
\fs24\lang2057\i\sbasedon1\snext5 caption;}
{\s6\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af6\afs24\lang25=
5\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2057\sb=
asedon1\snext6 Index;}
{\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\lang25=
5\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2057\sb=
asedon1\snext7 Preformatted Text;}
}
{\info{\creatim\yr2008\mo4\dy21\hr14\min29}{\revtim\yr2008\mo4\dy21\hr14\=
min46}{\printim\yr1601\mo1\dy1\hr0\min0}{\comment =
StarWriter}{\vern6800}}\deftab709
{\*\pgdsctbl
{\pgdsc0\pgdscuse195\pgwsxn11905\pghsxn16837\marglsxn1134\margrsxn1134\ma=
rgtsxn1134\margbsxn1134\pgdscnxt0 Standard;}}
\paperh16837\paperw11905\margl1134\margr1134\margt1134\margb1134\sectd\sb=
knone\pgwsxn11905\pghsxn16837\marglsxn1134\margrsxn1134\margtsxn1134\marg=
bsxn1134\ftnbj\ftnstart1\ftnrstcont\ftnnar\aenddoc\aftnrstcont\aftnstart1=
\aftnnrlc
\pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 Phase 1 - find and verify =
superblock...}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 Phase 2 - using internal =
log}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch         }{\rtlch =
\ltrch\loch\f0\fs24\lang2057\i0\b0 - scan filesystem freespace and inode =
maps...}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 bad magic # 0x58418710 =
for agi 0}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 bad version # 2 for agi =
0}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 would reset bad agi for =
ag 0}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 bad uncorrected agheader =
0, skipping ag...}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 bad magic # 0x4142940a in =
btcnt block 7/2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 expected level 0 got 3 in =
btcnt block 7/2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,288) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,289) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,296) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,297) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,302) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,296) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,297) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,298) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,333) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,334) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (7,403) already =
used, state 2}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 inode chunk claims used =
block, inobt block - agno 7, bno 3, inopb 16}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (14,421692) =
multiply claimed by bno space tree, state - 1}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (14,421693) =
multiply claimed by bno space tree, state - 1}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 block (14,421694) =
multiply claimed by bno space tree, state \uc3 \u8211\'e2\'80\'93\uc1  =
1}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057 {\rtlch \ltrch\loch\f0\fs24\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (14,971003) =
multiply claimed by bno space tree, state - 1}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (14,971004) =
multiply claimed by bno space tree, state - 1}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (14,971005) =
multiply claimed by bno space tree, state - 1}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 inode chunk claims used =
block, inobt block - agno 14, bno 3, inopb 16}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 inode chunk claims used =
block, inobt block - agno 14, bno 3, inopb 16}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 inode chunk claims used =
block, inobt block - agno 14, bno 3, inopb 16}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 inode chunk claims used =
block, inobt block - agno 14, bno 3, inopb 16}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic # 0xf816dffa in =
btcnt block 16/171879}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 expected level 1 got =
26155 in btcnt block 16/171879}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,5978200) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,5978203) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,5978205) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,5978207) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,68745) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,860197) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,785480) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (17,1866283) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic # 0x9ded151b in =
btbno block 22/2314}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 expected level 0 got =
46701 in btbno block 22/2314}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (22,110646) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (22,129495) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (22,129496) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (22,348309) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (22,348310) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (22,53743) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic # 0xa6bceb7b in =
btcnt block 25/44818}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 expected level 0 got =
55508 in btcnt block 25/44818}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (25,208993) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (25,160757) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic # 0xbe425443 in =
btcnt block 27/26679}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (27,201095) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (27,201096) already =
used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .block (27,4619369) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (27,4619370) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 block (27,4619371) =
already used, state 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 root inode chunk not =
found}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 Phase 3 - for each AG...}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch         }{\rtlch =
\ltrch\loch\f3\fs20\lang2057\i0\b0 - scan (but don't clear) agi unlinked =
lists...}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 error following ag 0 =
unlinked list}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 found inodes not in the =
inode allocation tree}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 found inodes not in the =
inode allocation tree}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch         }{\rtlch =
\ltrch\loch\f3\fs20\lang2057\i0\b0 - process known inodes and perform =
inode discovery...}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch         }{\rtlch =
\ltrch\loch\f3\fs20\lang2057\i0\b0 - agno =3D 0}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
131 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
132 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
133 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
188 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
189 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
190 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
191 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch         }{\rtlch =
\ltrch\loch\f3\fs20\lang2057\i0\b0 - agno =3D 1}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad bestfree table in =
block 5 in directory inode 268435584: would repair table}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
268435720 claims free block 369517041}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
268435720 claims free block 369517042}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
268435720 claims free block 369517043}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
270738556 claims free block 471793209}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
270738556 claims free block 471793210}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
270738556 claims free block 471793211}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad nblocks 5 for inode =
270738556, would reset to 97}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims in-use inode =
270738556 is free, would correct imap}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
270738557}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
270738557}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
270738558}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
270738558}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
270738559}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
270738559}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
270738592}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
270738593}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
270738594}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
270738753}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
270738753}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 270738901 claims used block 251703131}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
270738901}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
270738901}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch         }{\rtlch =
\ltrch\loch\f3\fs20\lang2057\i0\b0 - agno =3D 2}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad . entry in directory =
inode 536871040, was 536871045: would correct}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad . entry in directory =
inode 536871041, was 536871040: would correct}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad . entry in directory =
inode 536871045, was 536871049: would correct}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad . entry in directory =
inode 536871047, was 536871830: would correct}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad directory block magic =
# 0x58443242 in block 1 for directory inode 536871055}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 corrupt block 1 in =
directory inode 536871055}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 \tab would junk block}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
536871085 claims free block 419433502}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
536871092 claims free block 469762257}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
536871096 claims free block 143352225}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
536871096 claims free block 143352226}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 corrupt block 0 in =
directory inode 536871099}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 \tab would junk block}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no . entry for directory =
536871099}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no .. entry for directory =
536871099}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 problem with directory =
contents in inode 536871099}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
536871099}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
536871102 claims free block 134321130}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
536871102 claims free block 134321131}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
536871102 claims free block 134321132}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179589 claims free block 286348755}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179589 claims free block 286348756}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179589 claims free block 286348757}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179590 claims used block 303545771}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179590}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179590}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179591 claims used block 486729909}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179591}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179591}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179592 =
data fork is too large (size =3D 4939602, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179592}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179592}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179593 =
data fork is too large (size =3D 4168798, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179593}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179593}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179594 =
data fork is too large (size =3D 4325755, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179594}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179594}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179595 =
data fork is too large (size =3D 3233338, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179595}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179595}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179596 =
data fork is too large (size =3D 10360806, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179596}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179596}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179597 =
data fork is too large (size =3D 9502373, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179597}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179597}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179598 =
data fork is too large (size =3D 3250076, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179598}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179598}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179599 =
data fork is too large (size =3D 3133743, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179599}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179599}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179600 =
data fork is too large (size =3D 4085608, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179600}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179600}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179601 claims used block 285233312}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179601}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179601}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179602 =
data fork is too large (size =3D 3410791, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179602}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179602}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179603 =
data fork is too large (size =3D 2044592, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179603}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179603}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179604 =
data fork is too large (size =3D 3109201, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179604}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179604}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179605 =
data fork is too large (size =3D 1523100, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179605}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179605}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179606 =
data fork is too large (size =3D 1811725, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179606}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179606}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179607 =
data fork is too large (size =3D 1659849, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179607}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179607}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179608 claims used block 285322819}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179608}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179608}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179609 claims free block 436897527}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179609 claims free block 436897528}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179609 claims free block 436897529}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179614 claims free block 286243438}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179614 claims free block 286243439}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179615 claims used block 302854456}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179615}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179615}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2 on =
inode 1342179616}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179616}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xbbf7 =
on inode 1342179617}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x64 =
on inode 1342179617}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179617}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x4727 =
on inode 1342179618}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x43 =
on inode 1342179618}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179618}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x7649 =
on inode 1342179619}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffc1 on inode 1342179619}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179619}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x8985 =
on inode 1342179620}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffc1 on inode 1342179620}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179620}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x327b =
on inode 1342179621}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x57 =
on inode 1342179621}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179621}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x7627 =
on inode 1342179622}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3e =
on inode 1342179622}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179622}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5956 =
on inode 1342179623}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x5b =
on inode 1342179623}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179623}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x374a =
on inode 1342179624}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x7f =
on inode 1342179624}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179624}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x77ca =
on inode 1342179625}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3f =
on inode 1342179625}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179625}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x1983 =
on inode 1342179626}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x10 =
on inode 1342179626}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179626}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x3ef6 =
on inode 1342179627}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x70 =
on inode 1342179627}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179627}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x77a2 =
on inode 1342179628}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3f =
on inode 1342179628}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179628}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x3ed2 =
on inode 1342179629}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x7a =
on inode 1342179629}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179629}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x7791 =
on inode 1342179630}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3f =
on inode 1342179630}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179630}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x3bc2 =
on inode 1342179631}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x10 =
on inode 1342179631}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179631}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2 on =
inode 1342179616, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179616}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179616}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xbbf7 =
on inode 1342179617, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x64 =
on inode 1342179617, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179617}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179617}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x4727 =
on inode 1342179618, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x43 =
on inode 1342179618, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179618}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179618}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x7649 =
on inode 1342179619, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffc1 on inode 1342179619, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179619}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179619}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x8985 =
on inode 1342179620, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffc1 on inode 1342179620, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179620}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179620}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x327b =
on inode 1342179621, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x57 =
on inode 1342179621, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179621}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179621}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x7627 =
on inode 1342179622, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3e =
on inode 1342179622, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179622}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179622}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5956 =
on inode 1342179623, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x5b =
on inode 1342179623, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179623}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179623}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x374a =
on inode 1342179624, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x7f =
on inode 1342179624, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179624}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179624}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x77ca =
on inode 1342179625, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3f =
on inode 1342179625, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179625}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179625}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x1983 =
on inode 1342179626, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x10 =
on inode 1342179626, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179626}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179626}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x3ef6 =
on inode 1342179627, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x70 =
on inode 1342179627, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179627}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179627}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x77a2 =
on inode 1342179628, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3f =
on inode 1342179628, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179628}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179628}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x3ed2 =
on inode 1342179629, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x7a =
on inode 1342179629, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179629}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179629}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x7791 =
on inode 1342179630, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x3f =
on inode 1342179630, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179630}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179630}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x3bc2 =
on inode 1342179631, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x10 =
on inode 1342179631, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342179631}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179631}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179632 =
data fork is too large (size =3D 196095, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179632}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179632}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179633 =
data fork is too large (size =3D 366190, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179633}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179633}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179634 claims used block 235047448}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179634}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179634}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179635 =
data fork is too large (size =3D 395536, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179635}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179635}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179636 claims used block 235008106}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179636}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179636}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad bmap btree ptr =
0xc13a8acad6eab189 in ino 1342179639}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179639}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179639}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179640 claims used block 167823233}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179640}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179640}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 local inode 1342179642 =
data fork is too large (size =3D 210763, max =3D 156)}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179642}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179642}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad size/format for =
directory 1342179643}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 problem with directory =
contents in inode 1342179643}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179643}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 mismatch between format =
(1) and size (176557) in symlink inode 1342179645}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in symlink =
1342179645}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179645}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 mismatch between format =
(1) and size (541891) in symlink inode 1342179646}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in symlink =
1342179646}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179646}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 mismatch between format =
(1) and size (528780) in symlink inode 1342179647}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in symlink =
1342179647}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179647}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 mismatch between format =
(1) and size (97776) in symlink inode 1342179648}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in symlink =
1342179648}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179648}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 mismatch between format =
(1) and size (71351) in symlink inode 1342179649}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in symlink =
1342179649}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179649}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179654 claims used block 521054414}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179654}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179654}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in regular =
inode 1342179665 claims used block 135191770}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad data fork in inode =
1342179665}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342179665}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179670 claims free block 235329860}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179670 claims free block 235329861}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342179670 claims free block 235329862}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 .}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342181150 claims free block 387842929}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342181150 claims free block 387842930}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342181150 claims free block 387842931}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181186}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181200}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181201}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181202}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181203}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181204}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181205}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2 on =
inode 1342181216}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-8098840690732274055 on inode 1342181217}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x1b20 =
on inode 1342181218}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0xd on =
inode 1342181218}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-44603782713929781 on inode 1342181218}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xaf88 =
on inode 1342181219}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff9f on inode 1342181219}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181219}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xaf97 =
on inode 1342181220}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x64 =
on inode 1342181220}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-8598615031889885277 on inode 1342181220}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x4ed7 =
on inode 1342181221}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffab on inode 1342181221}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-7421484120082124244 on inode 1342181221}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xc784 =
on inode 1342181222}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff97 on inode 1342181222}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-7039745431618388759 on inode 1342181222}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x8654 =
on inode 1342181223}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff94 on inode 1342181223}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-7892964874975931737 on inode 1342181223}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb2b2 =
on inode 1342181224}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffd on inode 1342181224}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-2741290762856431056 on inode 1342181224}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb5f1 =
on inode 1342181225}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffd on inode 1342181225}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-145244644254024567 on inode 1342181225}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf045 =
on inode 1342181226}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffac on inode 1342181226}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-216457572855644921 on inode 1342181226}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb486 =
on inode 1342181227}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffc on inode 1342181227}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-4785780517491573548 on inode 1342181227}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xcb3 on =
inode 1342181228}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffff5 on inode 1342181228}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-218990860528255687 on inode 1342181228}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb449 =
on inode 1342181229}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffc on inode 1342181229}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-215894529477870567 on inode 1342181229}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x953a =
on inode 1342181230}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffd3 on inode 1342181230}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-4040222610815773810 on inode 1342181230}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x899d =
on inode 1342181231}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2 on =
inode 1342181231}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-6137713694427973127 on inode 1342181231}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x672a =
on inode 1342181233}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0xc on =
inode 1342181233}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181233}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181186}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181186}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181187 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181188 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181189 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181190 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181191 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181192 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181193 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181194 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181195 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181196 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181197 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181198 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181199 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181200}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181200}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181201}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181201}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181202}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181202}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181203}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181203}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181204}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181204}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181205}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181205}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181206 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181207 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181208 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181209 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181210 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181211 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181212 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181213 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181214 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181215 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2 on =
inode 1342181216, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181216 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181216}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-8098840690732274055 on inode 1342181217}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181217}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x1b20 =
on inode 1342181218, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0xd on =
inode 1342181218, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-44603782713929781 on inode 1342181218}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181218}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xaf88 =
on inode 1342181219, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff9f on inode 1342181219, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181219}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181219}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xaf97 =
on inode 1342181220, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x64 =
on inode 1342181220, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-8598615031889885277 on inode 1342181220}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181220}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x4ed7 =
on inode 1342181221, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffab on inode 1342181221, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-7421484120082124244 on inode 1342181221}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181221}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xc784 =
on inode 1342181222, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff97 on inode 1342181222, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-7039745431618388759 on inode 1342181222}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181222}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x8654 =
on inode 1342181223, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff94 on inode 1342181223, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-7892964874975931737 on inode 1342181223}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181223}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb2b2 =
on inode 1342181224, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffd on inode 1342181224, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-2741290762856431056 on inode 1342181224}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181224}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb5f1 =
on inode 1342181225, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffd on inode 1342181225, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-145244644254024567 on inode 1342181225}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181225}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf045 =
on inode 1342181226, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffac on inode 1342181226, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-216457572855644921 on inode 1342181226}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181226}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb486 =
on inode 1342181227, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffc on inode 1342181227, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-4785780517491573548 on inode 1342181227}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181227}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xcb3 on =
inode 1342181228, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffff5 on inode 1342181228, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-218990860528255687 on inode 1342181228}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181228}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xb449 =
on inode 1342181229, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xfffffffc on inode 1342181229, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-215894529477870567 on inode 1342181229}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181229}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x953a =
on inode 1342181230, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffd3 on inode 1342181230, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-4040222610815773810 on inode 1342181230}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181230}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x899d =
on inode 1342181231, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2 on =
inode 1342181231, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-6137713694427973127 on inode 1342181231}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181231}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181232 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x672a =
on inode 1342181233, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0xc on =
inode 1342181233, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181233}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181233}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181234 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181235 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181236 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181237 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181238 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181239 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181240 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181241 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181242 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181243 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181244 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181245 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181246 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181247 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0xf on =
inode 1342181296}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-8531373024821224668 on inode 1342181297}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x297c =
on inode 1342181298}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x56 =
on inode 1342181298}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181298}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5544 =
on inode 1342181299}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x1b =
on inode 1342181299}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181299}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x464e =
on inode 1342181300}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x52 =
on inode 1342181300}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181300}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xd440 =
on inode 1342181301}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x33 =
on inode 1342181301}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181301}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xd4b1 =
on inode 1342181302}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffc0 on inode 1342181302}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-5714591680202162485 on inode 1342181302}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x82d7 =
on inode 1342181303}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff8b on inode 1342181303}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-4027625441752728915 on inode 1342181303}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf0b9 =
on inode 1342181304}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffa0 on inode 1342181304}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-1404089711421248255 on inode 1342181304}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xa8cf =
on inode 1342181305}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffca on inode 1342181305}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181305}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5b52 =
on inode 1342181306}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x44 =
on inode 1342181306}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181306}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5d51 =
on inode 1342181311}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x65 =
on inode 1342181311}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181311}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x7 on =
inode 1342181312}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x2d28 =
on inode 1342181313}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x78 =
on inode 1342181313}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181313}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x641a =
on inode 1342181314}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2a =
on inode 1342181314}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181314}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x5 on =
inode 1342181328}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xa3fc =
on inode 1342181329}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x8381 =
on inode 1342181330}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x65 =
on inode 1342181330}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181330}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf2b7 =
on inode 1342181331}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x15 =
on inode 1342181331}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf2b3 =
on inode 1342181332}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x15 =
on inode 1342181332}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181332}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf543 =
on inode 1342181333}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x12 =
on inode 1342181333}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181333}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf55d =
on inode 1342181334}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181334}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342181281 claims free block 83886335}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 corrupt block 0 in =
directory inode 1342181281}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 \tab would junk block}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no . entry for directory =
1342181281}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no .. entry for directory =
1342181281}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 problem with directory =
contents in inode 1342181281}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181281}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342181282 claims free block 83886334}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 corrupt block 0 in =
directory inode 1342181282}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 \tab would junk block}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no . entry for directory =
1342181282}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no .. entry for directory =
1342181282}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 problem with directory =
contents in inode 1342181282}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181282}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342181283 claims free block 83886340}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad directory block magic =
# 0x5844b3a6 in block 0 for directory inode 1342181283}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 corrupt block 0 in =
directory inode 1342181283}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 \tab would junk block}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no . entry for directory =
1342181283}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 no .. entry for directory =
1342181283}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 problem with directory =
contents in inode 1342181283}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181283}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 data fork in ino =
1342181290 claims free block 83886341}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181292 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181293 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181294 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181295 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0xf on =
inode 1342181296, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181296 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181296}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-8531373024821224668 on inode 1342181297}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181297}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x297c =
on inode 1342181298, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x56 =
on inode 1342181298, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181298}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181298}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5544 =
on inode 1342181299, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x1b =
on inode 1342181299, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181299}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181299}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x464e =
on inode 1342181300, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x52 =
on inode 1342181300, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181300}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181300}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xd440 =
on inode 1342181301, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x33 =
on inode 1342181301, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181301}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181301}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xd4b1 =
on inode 1342181302, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffc0 on inode 1342181302, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-5714591680202162485 on inode 1342181302}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181302}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x82d7 =
on inode 1342181303, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffff8b on inode 1342181303, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-4027625441752728915 on inode 1342181303}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181303}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf0b9 =
on inode 1342181304, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffa0 on inode 1342181304, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad (negative) size =
-1404089711421248255 on inode 1342181304}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181304}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xa8cf =
on inode 1342181305, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number =
0xffffffca on inode 1342181305, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181305}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181305}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5b52 =
on inode 1342181306, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x44 =
on inode 1342181306, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181306}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181306}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181307 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181308 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181309 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181310 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x5d51 =
on inode 1342181311, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x65 =
on inode 1342181311, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181311}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181311}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x7 on =
inode 1342181312, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181312 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181312}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x2d28 =
on inode 1342181313, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x78 =
on inode 1342181313, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181313}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181313}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x641a =
on inode 1342181314, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x2a =
on inode 1342181314, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181314}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181314}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181315 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181316 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181317 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181318 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181319 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181320 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181321 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181322 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181323 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181324 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181325 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181326 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181327 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x5 on =
inode 1342181328, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 imap claims a free inode =
1342181328 is in use, would correct imap and clear inode}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181328}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xa3fc =
on inode 1342181329, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 mismatch between format =
(2) and size (56) in directory ino 1342181329}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181329}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0x8381 =
on inode 1342181330, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x65 =
on inode 1342181330, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad inode format in inode =
1342181330}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 would have cleared inode =
1342181330}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad magic number 0xf2b7 =
on inode 1342181331, would reset magic number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 bad version number 0x15 =
on inode 1342181331, would reset version number}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057 {\rtlch \ltrch\loch\f3\fs20\lang2057\i0\b0 Unexpected inode type =
0160000 inode 1342181331}
\par \pard\plain =
\ltrpar\s7\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af3\afs20\=
lang255\ltrch\dbch\af3\langfe255\hich\f3\fs20\lang2057\loch\f3\fs20\lang2=
057=20
\par \pard\plain =
\ltrpar\s1\cf0{\*\hyphen2\hyphlead2\hyphtrail2\hyphmax0}\rtlch\af5\afs24\=
lang255\ltrch\dbch\af4\langfe255\hich\f0\fs24\lang2057\loch\f0\fs24\lang2=
057=20
\par }
------=_NextPart_000_0038_01C8A3E9.4719A6B0--
