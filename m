Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A465B7CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:57:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6947E8F8035
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 05:57:16 -0700 (PDT)
Received: from mx.recia.fr (mx.recia.fr [95.128.41.47]) by cuda.sgi.com with
	ESMTP id Gy3NPQj5zZ9hsjdH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 05:57:11 -0700 (PDT)
Received: from e6530-damien.recia.fr (unknown [37.58.188.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested) (Authenticated sender: F12A086p)
	by mx.recia.fr (Postfix) with ESMTPSA id B5AE122602E
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 14:57:09 +0200 (CEST)
Subject: Re: Re: Cumulative xfsrestore shows many warnings and
	files/directories are missing after restoration
References: <8323ac3a-f9d2-ad31-69e3-1eea5a44dcde@recia.fr>
	<87a11f69-1a10-89e2-598f-015f0205a55a@sandeen.net>
From: Damien Gombault <damien.gombault@recia.fr>
Message-ID: <f3fb0f44-f7af-ce62-2037-2edb024426db@recia.fr>
Date: Wed, 1 Jun 2016 14:57:09 +0200
MIME-Version: 1.0
In-Reply-To: <87a11f69-1a10-89e2-598f-015f0205a55a@sandeen.net>
Content-Type: multipart/mixed; boundary="------------8EA2A3A708D8CFD2D40D45BC"
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
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------8EA2A3A708D8CFD2D40D45BC
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi.

Thank you for your answer.
I also open a report on Red Hat Bugzilla : 
https://bugzilla.redhat.com/show_bug.cgi?id=1341126
Eric answered me also on Bugzilla, I will continue on it.

Le 31/05/2016 à 15:57, Eric Sandeen a écrit :
> On 5/31/16 5:55 AM, Damien Gombault wrote:
>> Hi.
>>
>> I use xfsdump to backup my systems.
>> Recently I had to use xfsrestore to restore a cumulative level 0 + level 1 dumps.
>>
> ...
>
>> The level 1 restore shows many warnings :
>> xfsrestore: drive 0: examining media file 0
>> xfsrestore: drive 1: searching media for directory dump
>> xfsrestore: drive 1: reading directories
>> xfsrestore: drive 1: 11013 directories and 96122 entries processed
>> xfsrestore: drive 1: directory post-processing
>> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1677721775.4173752252 to dir var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/08 Sécurité/08c Gestion des mots de passe - Keepass: Aucun fichier ou dossier de ce type
>> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1711276202.4274102453 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/02 Mise en oeuvre sOlære: Aucun fichier ou dossier de ce type
>> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1694499004.2655526171 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/07 Communication: Aucun fichier ou dossier de ce type
>> xfsrestore: drive 1: WARNING: unable to rename dir orphanage/2365644069.2895542759 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/08 Sécurité/08c Gestion des mots de passe - Keepass: Aucun fichier ou dossier de ce type
>> xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474338.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt: Aucun fichier ou dossier de ce type
> Restating what I said in the bug you also filed:
>
> In general, it would helpful to provide the error messages after setting LANG=en_US - because your English is far better than my French.  :)
>
> A couple questions:
>
>> Some folders are not restored at the right place.
> What does that mean?  Were they restored to the wrong place, or were they not restored at all?
>
> Also, the "Aucun fichier ou dossier de ce type" errors indicate that files could not be moved into a directory hierarchy, presumably because some path component did not exist.
>
> The common portions of those paths which failed are:
>
>> var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/
> and
>
>> var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration
> Do those paths still exist on the original filesystem?  Is it possible that they were removed while the dump was occurring?
>
> It seems most likely that the filesystem changed significantly during the dump processes, and this is what led to the errors.
>
> -Eric
>


--------------8EA2A3A708D8CFD2D40D45BC
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


--------------8EA2A3A708D8CFD2D40D45BC
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------8EA2A3A708D8CFD2D40D45BC--
