Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 083537CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 08:57:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD5A7304048
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 06:57:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BWBT1AqGfLRott20 for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 06:57:46 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8E4942B18
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 08:57:45 -0500 (CDT)
Subject: Re: Cumulative xfsrestore shows many warnings and files/directories
	are missing after restoration
References: <8323ac3a-f9d2-ad31-69e3-1eea5a44dcde@recia.fr>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <87a11f69-1a10-89e2-598f-015f0205a55a@sandeen.net>
Date: Tue, 31 May 2016 08:57:45 -0500
MIME-Version: 1.0
In-Reply-To: <8323ac3a-f9d2-ad31-69e3-1eea5a44dcde@recia.fr>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 5/31/16 5:55 AM, Damien Gombault wrote:
> Hi.
> =

> I use xfsdump to backup my systems.
> Recently I had to use xfsrestore to restore a cumulative level 0 + level =
1 dumps.
> =


...

> The level 1 restore shows many warnings :
> xfsrestore: drive 0: examining media file 0
> xfsrestore: drive 1: searching media for directory dump
> xfsrestore: drive 1: reading directories
> xfsrestore: drive 1: 11013 directories and 96122 entries processed
> xfsrestore: drive 1: directory post-processing
> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1677721775.4=
173752252 to dir var/www/html/owncloud/data/F1000buv/files/Dossier personne=
l et source de partage/E-Administration/08 S=E9curit=E9/08c Gestion des mot=
s de passe - Keepass: Aucun fichier ou dossier de ce type
> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1711276202.4=
274102453 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier=
 personnel et source de partage/E-Administration/02 Mise en oeuvre sOl=E6re=
: Aucun fichier ou dossier de ce type
> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1694499004.2=
655526171 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier=
 personnel et source de partage/E-Administration/07 Communication: Aucun fi=
chier ou dossier de ce type
> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/2365644069.2=
895542759 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier=
 personnel et source de partage/E-Administration/08 S=E9curit=E9/08c Gestio=
n des mots de passe - Keepass: Aucun fichier ou dossier de ce type
> xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/290247433=
8.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel=
 et source de partage/E-Administration/09 Questionnaires communes sol=E6re/=
Dossiers des collectivit=E9s/37003 - Amboise/02-Compte rendu de r=E9unions/=
Compte rendu r=E9union 3 mai 2016.odt: Aucun fichier ou dossier de ce type

Restating what I said in the bug you also filed:

In general, it would helpful to provide the error messages after setting LA=
NG=3Den_US - because your English is far better than my French.  :)

A couple questions:

> Some folders are not restored at the right place.

What does that mean?  Were they restored to the wrong place, or were they n=
ot restored at all?

Also, the "Aucun fichier ou dossier de ce type" errors indicate that files =
could not be moved into a directory hierarchy, presumably because some path=
 component did not exist.

The common portions of those paths which failed are:

> var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de =
partage/E-Administration/

and

> var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et s=
ource de partage/E-Administration

Do those paths still exist on the original filesystem?  Is it possible that=
 they were removed while the dump was occurring?

It seems most likely that the filesystem changed significantly during the d=
ump processes, and this is what led to the errors.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
