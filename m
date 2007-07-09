Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 22:17:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l695HptL017022
	for <linux-xfs@oss.sgi.com>; Sun, 8 Jul 2007 22:17:52 -0700
Message-ID: <4691C1BA.4040603@sgi.com>
Date: Mon, 09 Jul 2007 15:03:54 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: usage pattern: xfsrestore to mirror disks
References: <f6r9pb$qv0$1@sea.gmane.org>
In-Reply-To: <f6r9pb$qv0$1@sea.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------000502090405050300030608"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jakob Praher <jp@hapra.at>
Cc: linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------000502090405050300030608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jakob,

Jakob Praher wrote:
> hi all,
> 
> first of all: I am a very happy user of xfs for a long time now.
> I use xfs in tandem with lvm2 and I have to say I am very pleased.
> 
> Now a question:
> 
> There are two modes of using xfs(dump,restore): non-cumulative and 
> cumulative. Is this cumulative mode also good to work with full dumps 
> (level0). E.g. the data I have to mirror is not large, and I don't want 
> to rely on inventory data. So I want for instance if between two full 
> dumps a file F was deleted, it should get deleted when I do xfsrestore 
> for the second time.
> 
> I don't keep the xfsdump output files but i just apply them via ssh. So 
> something like that would be great!
> 
> Maybe someone can shed some light on that.
> 

The cumulative mode really only relates to restore and not xfsdump.
xfsrestore in cumulative mode keeps its version of the directory tree
around (restoredir/xfsrestorehousekeepingdir/tree) so that it can use
it to compare with and decide if directory entries have been renamed,
deleted etc.. The code has been written to do this given an initial
level 0 dump and then delta dumps (incremental or resumed).
If you try to use a 2nd level 0 dump on restore then it will fail to
work - it won't restore anything.
It fails in xfsdump/restore/content.c/dumpcompat() when it
compares the restores uuid from persp->a.lastdumpid with the
incremental's uuid stored in scrhdrp->cih_last_id (and for a full
dump the cih_last_id won't be set).
Unfortunatly, a flag is set in restore so that it stops it from reporting
this error (not sure why).
I tried circumventing this uuid check (see the patch) and things
seemed to work ok (it did the renames and deletes).
However, I'm uncertain of any other repercussions - it's been a while
since I looked at cumulative restores. Maybe others might know.

I wonder if other tools might be useful to you... xfscopy,...?

--Tim




--------------000502090405050300030608
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="restore_hack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="restore_hack.patch"


===========================================================================
Index: xfsdump/restore/content.c
===========================================================================

--- a/xfsdump/restore/content.c	2007-07-09 14:41:15.000000000 +1000
+++ b/xfsdump/restore/content.c	2007-07-09 14:36:54.000000000 +1000
@@ -2019,7 +2019,7 @@ content_stream_restore( ix_t thrdix )
 		} else if ( dumpcompat( resumepr,
 					level,
 					*baseidp,
-					BOOL_FALSE )) {
+					BOOL_TRUE )) {
 			if ( uuid_compare( lastdumprejectedid,
 					 grhdrp->gh_dumpid) == 0) {
 				matchpr = BOOL_FALSE;
@@ -6762,7 +6762,7 @@ dumpcompat( bool_t resumepr, ix_t level,
 						  "selected dump not based on "
 						  "previously applied dump\n"));
 					}
-					return BOOL_FALSE;
+					/*return BOOL_FALSE;*/ return BOOL_TRUE;
 				}
 			}
 		}

--------------000502090405050300030608--
